package require

import "testing"

func NoError(t testing.TB, err error) {
	if err != nil {
		t.Fatal(err)
	}
}
