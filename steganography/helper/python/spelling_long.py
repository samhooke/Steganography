import sys, string, base64, spelling

if __name__ == '__main__':
	# Data is base64 encoded to avoid issues when passing
	sentence_encoded = file(sys.argv[1]).read().strip()
	sentence = base64.b64decode(sentence_encoded)
	sentence_corrected = spelling.correct_sentence(sentence)
	sentence_encoded = base64.b64encode(sentence_corrected)
	sys.stdout.write(sentence_encoded)
	#sys.stdout.write(sentence_encoded)