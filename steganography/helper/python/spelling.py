# Original spelling.py from: http://norvig.com/spell-correct.html

import sys, re, collections, os, base64, string

def words(text): return re.findall('[a-z]+', text.lower()) 

def train(features):
	model = collections.defaultdict(lambda: 1)
	for f in features:
		model[f] += 1
	return model

alphabet = 'abcdefghijklmnopqrstuvwxyz'

punctuation = ',.\'"!?'

NWORDS = train(words(file('steganography/helper/python/spelling_trainer.txt').read()))

def edits1(word):
	splits     = [(word[:i], word[i:]) for i in range(len(word) + 1)]
	deletes    = [a + b[1:] for a, b in splits if b]
	transposes = [a + b[1] + b[0] + b[2:] for a, b in splits if len(b)>1]
	replaces   = [a + c + b[1:] for a, b in splits for c in alphabet if b]
	inserts    = [a + c + b     for a, b in splits for c in alphabet]
	return set(deletes + transposes + replaces + inserts)

def known_edits2(word):
	return set(e2 for e1 in edits1(word) for e2 in edits1(e1) if e2 in NWORDS)

def known(words): return set(w for w in words if w in NWORDS)

def correct(word):
	candidates = known([word]) or known(edits1(word)) or known_edits2(word) or [word]
	return max(candidates, key=NWORDS.get)

def correct_sentence_words(sentence):
	for word in sentence.split():
		# Don't correct short words
		if len(word) <= 1:
			yield word
		else:
			# Remove punctuation (because correct() strips all punctuation)
			word_start = ''
			word_end = ''
			if word[0] in punctuation:
				word_start = word[0]
				word = word[1:]
			if word[len(word)-1] in punctuation:
				word_end = word[len(word)-1]
				word = word[:len(word)-1]

			word_corrected = correct(word)

			# Remember case
			if len(word) >= 1 and len(word_corrected) >= 1 and word[0].isupper():
				word_corrected = word_corrected[0].upper() + word_corrected[1:]

			# Put punctuation back
			if len(word_start) > 0:
				word_corrected = word_start + word_corrected
			if len(word_end) > 0:
				word_corrected = word_corrected + word_end
			
			yield word_corrected

def correct_sentence(sentence):
	return string.join(correct_sentence_words(sentence), ' ')

if __name__ == '__main__':
	# Data is base64 encoded to avoid issues when passing
	sentence_encoded = str(sys.argv[1])
	sentence = base64.b64decode(sentence_encoded)
	sys.stdout.write(correct_sentence(sentence), ' ')