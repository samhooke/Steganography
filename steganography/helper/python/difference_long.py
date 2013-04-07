import shlex, sys, difference

if __name__ == '__main__':
	ab = shlex.split(file(sys.argv[1]).read())
	sys.stdout.write(str(difference.difference(ab[0], ab[1])))