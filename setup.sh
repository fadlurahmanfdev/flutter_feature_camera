fvm use 3.10.6 && fvm global 3.10.6 \
  && fvm flutter clean && fvm flutter pub get \
  && cd example && fvm use 3.16.9 && fvm global 3.16.9 \
  && fvm flutter clean && fvm flutter pub get
