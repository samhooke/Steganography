import sys, shlex, difflib

def difference(a, b):
	d = difflib.SequenceMatcher(a=a, b=b)
	r = d.ratio()
	return r * 100

if __name__ == '__main__':
	ab = shlex.split(sys.argv[1])
	sys.stdout.write(str(difference(ab[0], ab[1])))