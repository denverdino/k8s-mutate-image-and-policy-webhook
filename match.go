package main

import "strings"

func isMatchedImage(image string, pattern string) bool {

	return len(pattern) == 0 || strings.HasPrefix(image, pattern+"/")
}

func convertMatchedImage(image string, pattern string, target string) string {
	if isMatchedImage(image, pattern) {
		return target + image[len(pattern):]
	}
	return image
}
