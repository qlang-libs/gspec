## gspec

Inspired by [RSpec](https://github.com/rspec) written in [qlang](github.com/qlang-libs/qlang) for golang BDD/TDD.

It's still on the progress of API design, feel free to open issues of suggestions.

### Install
```shell
cd $QLANG_PATH
git clone git@github.com:qlang-libs/gspec.git
```

### Example to integrate into `go test`

Prepare for the qlang interpreter
```go
package qlang

import (
	"log"
	"os"

	"qlang.io/qlang.v2/qlang"
	qall "qlang.io/qlang/qlang.all"
)

func New() *qlang.Qlang {
	qall.InitSafe(true)
	qlang, err := qlang.New(qlang.InsertSemis)
	qlang.SetLibs(os.Getenv("QLANG_PATH"))
	if err != nil {
		log.Panicln(err)
	}

	return qlang
}

func Import(mod string, table map[string]interface{}) {
	qlang.Import(mod, table)
}
```

Assuming that you are testing Corp API

```go
package corp

import (
	"io/ioutil"
	"testing"

	"your/package/of/qlang"
)

var qlang = qlang.New()

func TestCorp(t *testing.T) {
	// import t for geting t via `testingT.t` in qlang
	Import("testingT", map[string]interface{}{"t": t})

	// write testing into corp_test.ql
	code, err := ioutil.ReadFile("qlang.ql")
	if err != nil {
		t.Error(err)
	}

	err = qlang.SafeExec([]byte(code), "")
	if err != nil {
		t.Error(err)
	}
}
```

qlang testing file

```go
import "gspec"
import "expectations" as be

spec = new gspec.GSpec(testingT.t)

spec.describe("Corp", fn(self) {
	self.context("when passing no name", fn(self) {
		self.it("returns 400", fn(self) {
			self.expect(true).notTo(be.trusty)
		})
	})

	self.context("when passing name", fn(self) {
		self.it("returns 200", fn(self) {
			self.expect(true).to(be.trusty)
		})
	})
})
```

Finally change directory into corp package and run `go test -v`:

```shell
Test [Corp]:
	when passing no name, it returns 400. ×
	when passing name, it returns 200. √
--- FAIL: TestQlang (0.02s)
	asm_amd64.s:472: Test [Corp]: when passing name, it returns 400. Expect true not equals to true, but it did.
FAIL
exit status 1
FAIL	github.com/qlang-libs/qlang	0.025s
```



