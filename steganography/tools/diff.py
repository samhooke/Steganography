import sys, shlex

def difference(a, b):
	return a + ' wat ' + b

if __name__ == '__main__':
	ab = shlex.split(sys.argv[1])
	sys.stdout.write(difference(ab[0], ab[1]))