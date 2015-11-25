TITLE Prime Numbers     (ass_4.asm)

; Author: Frank Eslami
; Course / Project ID: CS271-400 / Project #4              Date: 11/8/2014
; Description: A program that calculates and displays prime numbers based on the user's input,
; which depicts how many prime numbers to display.

INCLUDE Irvine32.inc

PRIME_MIN = 1								;minimum integer the user's input may be
PRIME_MAX = 200								;maximum integer the user's input may be

.data
intro1			BYTE	"Welcome to Prime Numbers! My name is Frank Eslami. What is your name? ", 0
intro2			BYTE	", greetings. Enter the number of prime numbers you would like to see. I'll accept"
				BYTE	" orders from 1- 200: ", 0
invalidInput	BYTE	"Out of range. Please try again: ", 0
NotPrimeMess	BYTE	"Not a prime number.", 0
IsPrimeMess		BYTE	"Is prime.", 0
byeMess			BYTE	"Hello professor/TA. Despite hours of attemps to calculate the primes, I could not code the algorithm."
				BYTE	" Even though I understand the the concept of primes and went over the pseudocode many times, I kept"
				BYTE	" getting pretzeled up when trying to code it in assembly. In any case, I'm submitting this assignment in"
				BYTE	" hopes of partial credit since it's about procedures, which I believe I got right. Input vaildation"
				BYTE	" should also be working. Sorry, I tried, but my brain is now mush and I give up. This was a very"
				BYTE	" frustrating experience in midterm week for me. I was just overwhelmed this week. ", 0

userName		BYTE	20 DUP(0)			;store user's name
numOfPrimes		DWORD	?					;number of prime numbers to display
primeArray      DWORD	100 DUP(0)			;array to hold prime numbers
arraySize		DWORD	0					;primeArray size
currNumOuter	DWORD	0					;current number being iterated through until user's numOfPrimes is reached
currNumInner	DWORD	0
innerLow		DWORD	2					;inner loop numbers being tested for prime
innerHigh		DWORD	0					;inner loop highest number to test 

.code
;********************* START Procedure Definitions *********************

;intro
;Introduce the program, programmer, greet the user, and provide instructions
;Pre: none
;Post: user's name stored; number of prime numbers to display stored

intro PROC
	mov		edx, OFFSET intro1						;introduce program, programmer, and obtain name
	call	WriteString
	mov		edx, OFFSET userName					;store user's name
	mov		ecx, SIZEOF userName
	call	ReadString
	call	CrLf
	call	WriteString								;display user's name
	mov		edx, OFFSET intro2						;greet user and obtain the number of primes to display
	call	WriteString
	call	ReadInt									
	mov		numOfPrimes, eax						;store prime nummbers to display
	call	CrLf
	call	CrLf
	ret
intro ENDP
;---------------------------------------------------------------------------------------------------------

;validatePrime
;Validate that user's input is:  0 < input < 201
;Pre: global variable numOfPrimes is set to user's input
;Pre: PRIME_MIN and PRIME_MAX set to allowed floor and ceiling of user's input
;Post: sets numOfPrimes to an integer between  0 and 201

validatePrime PROC
	mov		eax, numOfPrimes						;user's input

	Validate:										;jump here if input is invalid
		cmp		eax, PRIME_MIN						;is user's input greater than or equal to the min?
		jl		InvalidInt							;user's input is less than min. Obtain new input
		cmp		eax, PRIME_MAX						;is user's input less than or equal to the max?
		jg		InvalidInt							;user's input is greater than max. Obtain new input
		jmp		ValidInt							;user's input is valid

	InvalidInt:										;obtain new integer from user
		mov		edx, OFFSET invalidInput			;warn user of invalid int input
		call	WriteString
		call	ReadInt								;obtain new integer input
		jmp		Validate							;validate new input
	
	ValidInt:										;input is valid
	ret
validatePrime ENDP
;---------------------------------------------------------------------------------------------------------

;calculate Prime
;Calculate primes based on user's input
;Pre: numOfPrimes set and validated
;Post: output prime numbers to user

calculatePrime PROC

COMMENT @
	THIS WAS MY FIRST ATTEMPT TO GET THE PRIME CALCULATION WORKING

	mov		currNumOuter, 0							;initate outer loop number to null
	mov		ecx, numOfPrimes						;set outer loop to user's number of primes to display
	L1:												;outer loop to test up to user's input
		inc		currNumOuter						;increment to next num to test for prime

	push	ecx										;save outer loop counter
	mov		ecx, currNumOuter						;set inner loop counter to current number being tested
	mov		currNumInner, 2							;start testing currNumOuter with 1st prime check number
	sub		ecx, 3									;adjust inner loop to no iterate through number 1 and current number
	mov		eax, currNumOuter
	push	currNumInner							;offsets pop in L2 initially
	L2:												;inner loop to test primes up to outer loops number
		pop		ebx									;pop currNumInner if not stored in array to clean stack	
		div		currNumInner
		cmp		edx, 0			
		je		IsPrime								;if remainder = 0, is prime
		jne		NotPrime							;if remainder != 0, is not prime. Test next number					

		IsPrime:									;number is prime, iterate current and test again
		push	currNumInner						;store current number in the event it's prime
		inc		currNumInner						;increment to next number to test against
		loop	L2									;test next number if currNumOuter not reached
		pop		primeArray							;store prime in array
		pop		ecx									;restore outer loop counter
		jmp		L1									;test next number in outer loop

		NotPrime:									;number is not prime
			pop		ecx								;restore outer loop counter
			inc		ecx								;increase counter to offset dec in loop call since no prime was found
			loop	L1								;test for next number

	
	;THIS WAS MY SECOND ATTEMPT TO GET THE PRIME CACULATION WORKING
	
	mov		currNumInner, 2
	L1:
		mov		eax, arraySize
		cmp		eax, numOfPrimes		
		je		AllPrimesFound
		inc		currNumOuter

		mov		ebx, currNumOuter
		;dec		ebx
		mov		innerHigh, ebx
	L2:
		mov		edx, 0
		mov		eax, currNumOuter
		div		currNumInner
		cmp		edx, 0
		je		NotPrime
		jne		IsPrime

		IsPrime:
		push	currNumInner
		inc		currNumInner
		mov		eax, innerHigh
		cmp		eax, currNumInner
		je		StorePrime
		pop		ebx
		mov		eax, currNumInner
		cmp		eax, innerHigh
		jae		L1
		jmp		L2

		NotPrime:
		mov		edx, OFFSET notPrimeMess
		call	WriteString
		inc		currNumInner
		mov		eax, currNumInner
		cmp		eax, innerHigh
		jae		L1
		jmp		L2

		StorePrime:
		pop		primeArray
		inc		arraySize
		jmp		L1

	AllPrimesFound:
@
	ret
calculatePrime ENDP
;---------------------------------------------------------------------------------------------------------

;sayBye
;Say goodbye and end the program
;Pre: none
;Pose: none

bye PROC
	mov		edx, OFFSET byeMess
	call	WriteString
	call	Crlf
	call	CrLf
	ret
bye ENDP

;********************* END Procedure Definitions *********************



main PROC
	call		intro				;introduce program and obtain user's input
	call		validatePrime		;validate user's input
	call		calculatePrime		;calcuate prime numbers up to user's input
	call		bye					;say goodbye

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
