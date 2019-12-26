build:
	wget --no-verbose -O mint https://mint-lang.s3-eu-west-1.amazonaws.com/mint-latest-linux
	chmod +x ./mint
	./mint install
	./mint build -e .env.production
