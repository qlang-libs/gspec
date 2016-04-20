import "expectations" as be 
import "types"

// GSpec acts as a director for testing contorlling
// Expample:
//   import "gspec"
// 	 spec = new gspec.GSpec	
// 
//   spec.describe("Corp", fn(self) {
//   	self.context("when passing no name", fn(self) {
//   		self.it("returns 400", fn(self) {
//   			self.expect(true).toBe(true)
//   		})
//   	})
// 
//   	self.context("when passing name", fn(self) {
//   		self.it("returns 200", fn(self) {
//   			self.expect(true).notToBe(true)
//   		})
//   	})
//   })
//
// 	 spec.result()
GSpec = class {
	fn _init(testingT) {
		this.testingT = testingT 
		this.describes = mkmap("string:var")
		this.failures = new types.Slice("string")
	}

	// describe creates a new Describe with the given name and GSpec itself, 
	// if the the given test is not a fn, it will panic.
	// It will run test by passing the new Describe.
	fn describe(name, test) {
		if !be.function(test)	{
			panic("GSpec#describe: the second param must be a fn")
		}

		name = fmt.sprintf("Test [%s]:", name)
		desc = this.describes[name]
		if desc == undefined {
			specObj = new Describe(this, name, test)
			this.describes[name] = specObj
			println(name)
			test(specObj)
		} else {
			panic(fmt.sprintf("GSpec#describe: the test name %s has been existed", name))
		}
	}

	// retsult returns this all tested Describe.
	// Return:
	//   map[string]interface{
	//	   "passed": true, //current result, maybe not the final result.
	// 		 "failures": types.Slice("string"), 
	//   } 
	fn result() {
		if this.failures.length() == 0 {
		  return {
				"passed": true,
				"failures": new types.Slice("string"),
			}
		} else {
			return {
				"passed": false,
				"failures": this.failures.mapping(fn(i, failure){
					return fmt.sprintf("%v. %s", i+1, failure)
				}),
			}
		}
	}
}

// Describe acts as an top wrapper for BDD.
Describe = class {
	fn _init(gspec, name, test) {
		this.gspec = gspec
		this.name = name
		this.test = test
	}

	// context creates a new Context with the given name and GSpec itself, 
	// if the the given test is not a fn, it will panic.
	// It will run test by passing the new Context.
	fn context(condition, test) {
		if !be.function(test)	{
			panic("Describe#context: the second param must be a fn")
		}
		printf(fmt.sprintf("	%s, ", condition))
		condition = fmt.sprintf("%s %s,", this.name, condition)
		ctx = new Context(this.gspec, condition, test)
		test(ctx)
	}
}

Context = class {
	fn _init(gspec, condition, test) {
		this.gspec = gspec
		this.condition = condition
		this.test = test
	}

	// it creates a new It with the given name and GSpec itself, 
	// if the the given test is not a fn, it will panic.
	// It will run test by passing the new It.
	fn it(assertion, test) {
		if !be.function(test)	{
			panic("Describe#context: the second param must be a fn")
		}

		assertStr = fmt.sprintf("it %s. ", assertion)
		printf(assertStr)
		assertion = fmt.sprintf("%s %s", this.condition, assertStr)
		test(new It(this.gspec, assertion, test))
	}
}

It = class {
	fn _init(gspec, assertion, test) {
		this.gspec = gspec
		this.assertion = assertion
		this.test = test
	}

	// expect creates and returns a new Expect with the given testObj. 
	fn expect(testObj) {
		return new Expect(this.gspec, this.assertion, testObj)
	}
}

Expect = class {
	fn _init(gspec, assertion, testObj) {
		this.gspec = gspec
		this.assertion = assertion
		this.testObj = testObj
	}

	fn to(expectation) {
		this.assertion = fmt.sprintf("%sExpect %v %s, but it didn't.", this.assertion, this.testObj, expectation.description)
		result = expectation.assert(this.testObj)
		this.outputs(result)
		return result
	}

	fn notTo(expectation) {
		this.assertion = fmt.sprintf("%sExpect %v not %s, but it did.", this.assertion, this.testObj, expectation.description)
		result = !expectation.assert(this.testObj)
		this.outputs(result)
		return result
	}

	fn outputs(result) {
		if result {
			println("√")
		} else {
			this.gspec.failures.push(this.assertion)
			if this.gspec.testingT != nil {
				this.gspec.testingT.Error(this.assertion)
			}
			println("×")
		}
	}
}


