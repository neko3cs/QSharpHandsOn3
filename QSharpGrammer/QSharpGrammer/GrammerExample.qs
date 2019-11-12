namespace Quantum.QSharpGrammer
{
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    operation GrammerExample () : Unit {
		Arrays2();

		NumericExpressions();
    }

	operation QubitExample1(bits: Int): Unit {
		using (q = Qubit()) {
			// ...
		}
		using ((ancilla, qubits) = (Qubit(), Qubit[bits * 2 + 3])) {
			// ancilla はQubit
			// qubitsはQubit[]
		}

		borrowing (q = Qubit()) {
			// ...
			//Measureなど測定はNG
		}
		borrowing ((ancilla, qubits) = (Qubit(), Qubit[bits * 2 + 3])) {
			// ...
		}
	}

	operation MeasureTwice(q1: Qubit, p1: Pauli, q2: Qubit, p2: Pauli): (Result, Result) {
		return (Measure([p1], [q1]), Measure([p2], [q2]));
	}

	operation VariableExample(): Unit {
		let (i, f) = (5, 0.1); // i is bound to 5 and f to 0.1
		mutable (a, (_, b)) = (1, (2, 3)); // a is bound to 1, b is bound to 3
		mutable (x, y) = ((1, 2), [3, 4]); // x is bound to (1,2), y is bound to [3,4]
		set (x, _, y) = ((5, 6), 7, [8]);  // x is rebound to (5,6), y is rebound to [8]
		using((q1, q2) = (Qubit(), Qubit())) {
			let (r1, r2) = MeasureTwice(q1, PauliX, q2, PauliY);
		}
	}
		
	operation Tupples() : Unit {
		let ints = (3,50);
		if (5 == (5)) {
			Message("5 is equal to (5)");
		} else {
			Message("5 is not equal to (5)");
		}
	}

	newtype Complex = (Re : Double, Im : Double);

	function Addition (c1 : Complex, c2 : Complex) : Complex {
		return Complex(c1::Re + c2::Re, c1::Im + c2::Im);
	}

	function PrintMsg (value : Complex) : Unit {
		let (re, im) = value!; //unwrap 
		Message ($"Re:{re}, Im:{im}");
	}

	operation Ranges(): Unit {
		Message("Range: 1..3");
		for (i in 1..3) {
			Message($"{i}");
		}
		Message("Range: 2..2..5");
		for (i in 2..2..5) {
			Message($"{i}");
		}
		Message("Range: 2..2..6");
		for (i in 2..2..6) {
			Message($"{i}");
		}
		Message("Range: 6..-2..2");
		for (i in 6..-2..2) {
			Message($"{i}");
		}
		Message("Range: 2..1");
		for (i in 2..1) {
			Message($"{i}");
		}
		Message("Range: 2..6..7");
		for (i in 2..6..7) {
			Message($"{i}");
		}
		Message("Range: 2..2..1");
		for (i in 2..2..1) {
			Message($"{i}");
		}
	}
	
	function NumericExpressions() : Unit {
		let zero = 0;
		let hex = 0xdeadbeaf;
		let bigZero = 0L;
		let bigHex = 0x123456789abcdef123456789abcdefL;
		let bigOne = bigZero + 1L;
		//let bigSum = zero + bigHex; //compile error
		let bigSum = IntAsBigInt(zero) + bigHex;

		let module = 4 % 3;
		let power = 4 ^ 3;
		Message($"4^3 = {power}");
		let powerDouble = 4.2 ^ 3.2;
		Message($"4.2^3.2 = {powerDouble}");
		let bitwiseAnd = 0b101 &&& 0b111;
		Message($"0b101 AND 0b111 = {bitwiseAnd}");
		let bitwiseOr = 0b101 ||| 0b111;
		Message($"0b101 OR 0b111 = {bitwiseOr}");
		let bitwiseXor = 0b101 ^^^ 0b111;
		Message($"0b101 XOR 0b111 = {bitwiseXor}");

		let leftShift = 1 <<< 3;
		Message($"1 left shift 3 = {leftShift}");
		let rightShift = 0b1000 >>> 3;
		Message($"0b1000 right shift 3 = {rightShift}");
	}

	//このoperationを定義するとQ#コード全体がなぜか正しくコンパイルできなくなる
	//operation Func<'T1, 'T2>(op1: 'T1, op2: 'T2, op3: 'T1): 'T2 {
	//	return op2;
	//}

	operation Op1(qubits: Qubit[]): Unit is Adj {
	
	}

	operation Op2(qubits: Qubit[]): Unit is Adj {
	
	}

	operation Op3(qubits: Qubit[]): Unit {
	
	}

	operation CallerableExample(): Unit {
		//このコードがコンパイルできるとドキュメントになるがなぜかエラー
		//let combinedOp = Func<(Qubit[] => Unit), (Qubit[] => Unit is Adj)>(Op1, Op2, Op3);
	}

	//部分適用

	function AddBuilder(num: Int): (Int -> Int){
		return Add(_, num);
	}

	function Add(num1: Int, num2: Int): Int {
		return num1 + num2;
	}

	function AddBuilderExample(): Unit {
		let op = AddBuilder(4);
		let res1 = op(3);

		//変数に格納せず実行
		let re2 = (AddBuilder(5))(4);
	}

	operation Op<'T1>(value1: 'T1, qubit: Qubit, value2: 'T1): Unit is Adj {
		
	}

	operation OpExample(): Unit {
		using(qb = Qubit()) {
			let f1 = Op<Int>(_, qb, _); // f1 has type ((Int,Int) => Unit is Adj)
			let f2 = Op(5, qb, _);      // f2 has type (Int => Unit is Adj)
			//let f3 = Op(_,qb, _);       // f3 generates a compilation error
		}
	}

	//三項演算子
	operation Op4(qubits: Qubit[]): Unit is Adj{
	
	}

	operation Op5(qubits: Qubit[]): Unit is Ctl {
	
	}

	operation Op6(qubits: Qubit[]): Unit is Adj+Ctl {
	
	}

	operation ConditionalExpressionExample(flag: Bool): Unit {
		//let opA = flag ? Op4 | Op5; //(Qubit[] => Unit)
		let opB = flag ? Op4 | Op6; //(Qubit[]=> Unit is Adj)
		let opC = flag ? Op5 | Op6; //(Qubit[]=> Unit is Ctl)
	}

	//Documentation

	/// # Summary
	/// Given an operation and a target for that operation,
	/// applies the given operation twice.
	///
	/// # Input
	/// ## op
	/// The operation to be applied.
	/// ## target
	/// The target to which the operation is to be applied.
	///
	/// # Type Parameters
	/// ## 'T
	/// The type expected by the given operation as its input.
	///
	/// # Example
	/// ```Q#
	/// // Should be equivalent to the identity.
	/// ApplyTwice(H, qubit);
	/// ```
	///
	/// # See Also
	/// - Microsoft.Quantum.Intrinsic.H
	operation ApplyTwice<'T>(op : ('T => Unit), target : 'T) : Unit
	{
		op(target);
		op(target);
	}

	//制御構文
	operation ForLoopExample(): Unit {
		using(qubits = Qubit[5]) {
			for (qb in qubits) { // qubits contains a Qubit[]
				H(qb);
			}

			mutable results = new (Int, Result)[Length(qubits)];
			for (index in 0 .. Length(qubits) - 1) {
				set results w/= index <- (index, M(qubits[index]));
			}

			mutable accumulated = 0;
			for ((index, measured) in results) {
				if (measured == One) {
					set accumulated += 1 <<< index;
				}
			}
		}
	}

	//https://arxiv.org/abs/1311.1074
	operation RepeatUntilSuccessExample(target: Qubit): Unit {
		using (anc = Qubit()) {
			repeat {
				H(anc);
				T(anc);
				CNOT(target,anc);
				H(anc);
				Adjoint T(anc);
				H(anc);
				T(anc);
				H(anc);
				CNOT(target,anc);
				T(anc);
				Z(target);
				H(anc);
				let result = M(anc);
			} 
			until (result == Zero)
			fixup {
				//do nothing in this case
			}
		}
	}

	function WhileExample(arr: Int[]): Unit {
		mutable (item, index) = (-1, 0);
		while (index < Length(arr) and item < 0) { 
			set item = arr[index];
			set index += 1;
		}
	}

	
	operation ApplyWith<'T>(
		outerOperation : ('T => Unit is Adj), 
		innerOperation : ('T => Unit), 
		target : 'T) 
	: Unit {

		outerOperation(target);
		innerOperation(target);
		Adjoint outerOperation(target);
	}

	operation ApplyWithEx<'T>(
		outerOperation : ('T => Unit is Adj), 
		innerOperation : ('T => Unit), 
		target : 'T) 
	: Unit {

		within{ 
			outerOperation(target);
		}
		apply {
			innerOperation(target);
		}
	}
}

namespace NS {

	open Microsoft.Quantum.Intrinsic; // opens the namespace
	open Microsoft.Quantum.Math as Math; // defines a short name for the namespace
}