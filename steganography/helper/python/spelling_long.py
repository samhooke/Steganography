import sys, string, spelling

if __name__ == '__main__':
	sentence = file(sys.argv[1]).read()
	sys.stdout.write(string.join(spelling.correct_sentence(sentence), ' '))