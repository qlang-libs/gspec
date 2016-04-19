include "gspec.ql"

spec = new GSpec

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
println(spec.result().failures)

// test failures
fn {
	if spec.failures.length() != 2 {
		println("gspec can not test, failures are:", spec.failures)
	}
}
