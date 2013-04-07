import sys, shlex, difflib

def difference(a, b):
	return difflib.SequenceMatcher(a=a, b=b).ratio() * 100

if __name__ == '__main__':
	ab = shlex.split(sys.argv[1])
	sys.stdout.write(str(difference(ab[0], ab[1])))