import "gspec"
import "expectations" as be

spec = new gspec.GSpec(nil)

spec.describe("Corp", fn(self) {
	self.context("when passing no name", fn(self) {
		self.it("returns 200", fn(self) {
			self.expect(true).to(be.trusty)
		})
	})

	self.context("when passing name", fn(self) {
		self.it("returns 400", fn(self) {
			self.expect(true).notTo(be.trusty)
		})
	})
})

spec.describe("Dish", fn(self) {
	self.context("when passing no name", fn(self) {
		self.it("returns 200", fn(self) {
			self.expect(true).to(be.trusty)
		})
	})

	self.context("when passing name", fn(self) {
		self.it("returns 400", fn(self) {
			self.expect(true).to(be.falsity)
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
