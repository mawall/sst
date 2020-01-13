install_cryfs(){
  sudo apt install -y libcurl4-openssl-dev libssl-dev libfuse-dev
  pip install conan
  git clone https://github.com/cryfs/cryfs.git cryfs && cd cryfs
  mkdir build && cd build
  conan install .. --build=missing -s compiler.libcxx=libstdc++11
  cmake ..
  make && sudo make install
  cd ~ && rm -rf cryfs
}