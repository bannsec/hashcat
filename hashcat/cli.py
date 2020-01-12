
import os
import platform
import subprocess
import sys

def main():
    args = sys.argv[1:] if len(sys.argv) > 1 else []
    
    # Light passthrough
    subprocess.run([hashcat_exe_path] + args)

bits = platform.architecture()[0][:-3]
ext = ".exe" if platform.uname().system == "Windows" else ".bin"

here = os.path.dirname(os.path.realpath(__file__))
hashcat_dir = os.path.join(here, "hashcat")
hashcat_exe = "hashcat"  + bits + ext
hashcat_exe_path = os.path.join(hashcat_dir, hashcat_exe)

if __name__ == "__main__":
    main()
