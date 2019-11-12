namespace Quantum.QSharpGrammer
{
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;

    operation Arrays() : Unit
    {
        ArraysExample();
    }
		
	operation Arrays2() : Unit {
		let zeros = new Int[13];
		let arr = [10, 11, 36, 49];
		let ten = arr[0]; // 10
		Message($"{ten}");
		let combined = zeros + arr;
		Message($"{combined}");
	}

	//C#には多次元配列とJaggedArray（配列の配列）があるが、
	//Q#にはJaggedArrayのみ
	function JaggedArrayExample(): Unit {
		let N = 4;
		mutable multiplicationTable = new Int[][N];
		for (i in 1..N) {

			mutable row = new Int[i];
			for (j in 1..i) {
				set row w/= j-1 <- i * j;
			}
			set multiplicationTable w/= i-1 <- row;
		}
	}

	operation ArraySlices(): Unit {
		let arr = [1,2,3,4,5,6];
		let slice1  = arr[3...];      // slice1 is [4,5,6];
		let slice2  = arr[0..2...];   // slice2 is [1,3,5];
		let slice3  = arr[...2];      // slice3 is [1,2,3];
		let slice4  = arr[...2..3];   // slice4 is [1,3];
		let slice5  = arr[...2...];   // slice5 is [1,3,5];
		let slice7  = arr[4..-2...];  // slice7 is [5,3,1];
		let slice8  = arr[...-1..3];  // slice8 is [6,5,4];
		let slice9  = arr[...-1...];  // slice9 is [6,5,4,3,2,1];
		let slice10 = arr[...];       // slice10 is [1,2,3,4,5,6];
	}

	function CopyAndUpdateExpressions() : Unit {
		let array = [0,1,2,3];
		let array2 = array w/ 0 <- 10;
		let array3 = array w/ 2 <- 10;
		let array4 = array w/ 0..2..3 <- [10,12];
	}

	function AddAll (reals : Double[], ims : Double[]) : Complex {
		mutable res = Complex(0.,0.);

		for (r in reals) {
			set res w/= Re <- res::Re + r; // update-and-reassign statement
		}
		for (i in ims) {
			set res w/= Im <- res::Im + i; // update-and-reassign statement
		}
		return res;
	}

	function ArraysExample() : Unit {
		let arr1 = [1,2,3,4,5];
		let arr2 = [2,4,6,8,10];
		let arr3 = ConstantArray(5, 1);
		Message($"{arr3}");
		
		let res1 = All(IsEven, arr1);
		Message($"{res1}");
		let res2 = All(IsEven, arr2);
		Message($"{res2}");

		let res3 = Any(IsEven, arr1);
		Message($"{res1}");
		let res4 = Any(IsEven, arr3);
		Message($"{res2}");

		for ((idx, val) in Enumerated(arr2)) {
			Message($"{idx}:{val}");
		}

		let array = SequenceI(10,15);
		// The following line returns [10, 12, 15].
		let subarray = Exclude([1, 3, 4], array);
		Message($"{subarray}");

		let res5 = Filtered(IsEven, arr1);
		Message($"{res5}");

		let res6 = Sum(arr1);
		Message($"{res6}");

		let res7 = Head(arr1);
		Message($"{res7}");

		let res8 = IndexOf(IsEven, arr1);
		Message($"{res8}");

		for (idx in IndexRange(arr2)) {
			Message($"{idx}");
		}

		let func = LookupFunction([3,5,7]);
		let res9 = func(2);
		Message($"{res9}");

		let res10 = Mapped(IsEven, arr1);
		Message($"{res10}");

		let res11 = MappedByIndex(Plus, arr1);
		Message($"{res11}");

		let res12 = Most(arr1);
		Message($"{res12}");

		let res13 = Padded(-12, 2, array);
		Message($"{res13}");
		let res14 = Padded(12, 2, array);
		Message($"{res14}");

		let res15 = Partitioned([1,2],arr1);
		Message($"{res15}");

		let res16 = Rest(arr1);
		Message($"{res16}");

		let res17 = Reversed(arr1);
		Message($"{res17}");

		let res18 = SequenceL(-19L,-15L);
		Message($"{res18}");

		let res19 = Subarray([4,2,4], arr1);
		Message($"{res19}");

		let res20 = Tail(arr1);
		Message($"{res20}");

		let left = [1, 3, 71];
		let right = [false, true];
		let third = [0.1, -0.5, 0.];
		let fourth = [PauliX];

		let res21 = Zip(left, right);
		Message($"{res21}");

		let res22 = Zip3(left, right, third); 
		Message($"{res22}");

		let res23 = Zip4(left, right, third, fourth); 
		Message($"{res23}");
	}

	function IsEven(num: Int): Bool {
		return num % 2 == 0;
	}

	function Plus(a : Int, b : Int): Int {
		return a + b;
	}

	function Sum(xs : Int[]): Int {
		return Fold(Plus, 0, xs);
	}

	operation ArraysOperationExample(): Unit {
		using (qbs = Qubit[5]) {
			let results = ForEach(M, qbs);
		}
	}
}
