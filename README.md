## gspec

Inspired by [RSpec](https://github.com/rspec) written in [qlang](github.com/qlang-libs/qlang) for golang BDD/TDD.

It's still on the progress of API design, feel free to open issues of suggestions.

### Install
```shell
cd $QLANG_PATH
git clone git@github.com:qlang-libs/gspec.git
```

### Example
```go
import "gspec.ql"

spec = new gspec.GSpec

spec.describe("Corp", fn(self) {
	self.context("when passing no name", fn(self) {
		self.it("returns 400", fn(self) {
			self.expect(true).toBe(true)
		})
	})

	self.context("when passing name", fn(self) {
		self.it("returns 200", fn(self) {
			self.expect(true).notToBe(true)
		})
	})
})

spec.describe("Dish", fn(self) {
	self.context("when passing no name", fn(self) {
		self.it("returns 400", fn(self) {
			self.expect(true).toBe(true)
		})
	})

	self.context("when passing name", fn(self) {
		self.it("returns 200", fn(self) {
			self.expect(true).toBe(false)
		})
	})
})

// test result
println(spec.result().failures.length()) // Outputs: 2
```

