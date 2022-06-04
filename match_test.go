package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestIsMatchedImage(t *testing.T) {
	var (
		image1   = "gcr.io/k8s-prow/test"
		pattern1 = "gcr.io/k8s-prow"
		pattern2 = "gcr.io/k8s-rear"
		pattern3 = ""
	)

	assert.True(t, isMatchedImage(image1, pattern1), "should be matched")
	assert.False(t, isMatchedImage(image1, pattern2), "should not be matched")
	assert.True(t, isMatchedImage(image1, pattern3), "should be matched")
}

func TestConvertMatchedImage(t *testing.T) {
	var (
		image   = "gcr.io/k8s-prow/test:v1"
		pattern = "gcr.io/k8s-prow"
		target  = "mytest:5000/k8s-prow"
	)

	assert.Equal(t, convertMatchedImage(image, pattern, target), "mytest:5000/k8s-prow/test:v1", "should be same")
}
