const fs = require("node:fs/promises");
const os = require("node:os");
const path = require("node:path");
const koffi = require("koffi");

const AT_FDCWD = -100;
const RENAME_NOREPLACE = 1;

async function main() {
  const libc = koffi.load("/system/lib64/libc.so");
  const renameat2 = libc.func(
    "int renameat2(int, const char *, int, const char *, unsigned int)"
  );

  const dir = await fs.mkdtemp(path.join(os.tmpdir(), "dsh-renameat2-"));
  const source = path.join(dir, "source.tmp");
  const destination = path.join(dir, "destination");

  try {
    await fs.writeFile(source, "first");
    const first = renameat2(AT_FDCWD, source, AT_FDCWD, destination, RENAME_NOREPLACE);
    if (first !== 0) {
      throw new Error(`renameat2 to new destination failed; errno=${koffi.errno()}`);
    }

    if ((await fs.readFile(destination, "utf8")) !== "first") {
      throw new Error("Destination content mismatch after first publish");
    }

    await fs.writeFile(source, "second");
    const second = renameat2(AT_FDCWD, source, AT_FDCWD, destination, RENAME_NOREPLACE);
    const errno = koffi.errno();

    if (second !== -1 || errno !== 17) {
      throw new Error(`Expected EEXIST (17), got result=${second}, errno=${errno}`);
    }

    if ((await fs.readFile(destination, "utf8")) !== "first") {
      throw new Error("Existing destination was unexpectedly overwritten");
    }

    console.log("PASS: atomic no-clobber publish and EEXIST behavior");
  } finally {
    await fs.rm(dir, { recursive: true, force: true });
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
