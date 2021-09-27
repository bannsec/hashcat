
import os
import platform
import subprocess
import sys

def main():
    args = sys.argv[1:] if len(sys.argv) > 1 else []

    # Because hashcat devs can't figure out how to handle paths...
    # https://github.com/hashcat/hashcat/issues/2288
    for i, arg in enumerate(args):
        # Implicitly determine if this is a path and if so, make it absolute
        if os.path.exists(arg):
            args[i] = os.path.abspath(arg)
    
    # Light passthrough
    subprocess.run([hashcat_exe_path] + args, cwd=hashcat_dir)

# hashcat dropped 32-bit support
#bits = platform.architecture()[0][:-3]
ext = ".exe" if platform.uname().system == "Windows" else ".bin"

here = os.path.dirname(os.path.realpath(__file__))
hashcat_dir = os.path.join(here, "hashcat")
hashcat_exe = "hashcat"  + ext
hashcat_exe_path = os.path.join(hashcat_dir, hashcat_exe)

if __name__ == "__main__":
    main()
