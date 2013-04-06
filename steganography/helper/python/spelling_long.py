import sys, string, base64, spelling

if __name__ == '__main__':
	sentence_encoded = file(sys.argv[1]).read().strip()
	#sys.stdout.write('a' + sentence_encoded + 'b' + 'c')
	sentence = base64.b64decode(sentence_encoded)
	sys.stdout.write(string.join(spelling.correct_sentence(sentence), ' '))