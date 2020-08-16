"
- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #MatrixVisualisation,
	#superclass : #Object,
	#instVars : [
		'a',
		'b',
		'c',
		'n',
		'p',
		'pSize',
		'pSqrt',
		'canvas',
		'shapesA',
		'labelsA',
		'shapesB',
		'labelsB',
		'labelsC',
		's',
		'shapesProcess'
	],
	#category : #CannonsMMVisualisation
}

{ #category : #'accessing - attributes' }
MatrixVisualisation >> a [
	^a 
]

{ #category : #private }
MatrixVisualisation >> addAnimations [
	| sumI sumJ |
	sumI := 0.
	sumI := 1 to: n do: [ :i | 
		i > 2
			ifTrue: [ sumI := (sumI + i - 2). ].
		sumJ := 0.
		1 to: n do: [ :j |
			j > 2
				ifTrue: [ sumJ := (sumJ + j - 2). ].
			self waitA: (Visualisation new phase: 1; i: i; vi: i; j: j; vj: j; moves: i - 1; firstWait: sumI; secondWait: (s * 2 - i + 1 - sumI)).
			self waitALabels: (Visualisation new phase: 1; i: i; vi: i; j: j; vj: j; moves: i - 1; firstWait: sumI; secondWait: (s * 2 - i + 1 - sumI)).
			self waitB: (Visualisation new phase: 1; i: i; vi: i; j: j; vj: j; moves: j - 1; firstWait: (s + sumJ); secondWait: (s - j + 2 - sumJ)).
			self waitBLabels: (Visualisation new phase: 1; i: i; vi: i; j: j; vj: j; moves: j - 1; firstWait: (s + sumJ); secondWait: (s - j + 2 - sumJ)).
			
		].
	].
]

{ #category : #'accessing - attributes' }
MatrixVisualisation >> b [
	^b
]

{ #category : #'accessing - attributes' }
MatrixVisualisation >> c [
	^c
]

{ #category : #'accessing - attributes' }
MatrixVisualisation >> canvas [
	^canvas
]

{ #category : #private }
MatrixVisualisation >> createShapesAndLabels [
	canvas := RSCanvas new. 
	self createShapesProcess.
	self createShapesAndLabelsC.
	self createShapesAndLabelsB.
	self createShapesAndLabelsA.

]

{ #category : #private }
MatrixVisualisation >> createShapesAndLabelsA [
	shapesA := OrderedCollection new.
	labelsA := OrderedCollection new.
	1 to: n do: [ :i| 
	shapesA add: OrderedCollection new.
	labelsA add: OrderedCollection new.
	1 to: n do: [ :j |
		| boxA labelA |
		boxA := (RSBox new extent: n*3@n;color: Color lightBlue; x:j*(n*9); y:i*(n*3)).
		labelA := (RSLabel new text: ((a at:i) at:j); x:j*(n*9); y:i*(n*3); fontSize: n/2).
		canvas addShape: boxA.
		canvas add: labelA.
		(shapesA at: i) add: boxA.
		(labelsA at: i) add: labelA.
	].
].
]

{ #category : #private }
MatrixVisualisation >> createShapesAndLabelsB [
	shapesB := OrderedCollection new.
	labelsB := OrderedCollection new.
	1 to: n do: [ :i| 
	shapesB add: OrderedCollection new.
	labelsB add: OrderedCollection new.
	1 to: n do: [ :j |
		| boxB labelB |
		boxB := (RSBox new extent: n*3@n;color: Color lightRed; x:j*(n*9)+(n*3); y:i*(n*3)).
		labelB := (RSLabel new text: ((b at:i) at:j); x:j*(n*9)+(n*3); y:i*(n*3); fontSize: n/2).
		canvas addShape: boxB.
		canvas add: labelB.
		(shapesB at: i) add: boxB.
		(labelsB at: i) add: labelB.
	].
].
]

{ #category : #private }
MatrixVisualisation >> createShapesAndLabelsC [
	labelsC := OrderedCollection new.
	1 to: n do: [ :i| 
	labelsC add: OrderedCollection new.
	1 to: n do: [ :j |
		| boxC labelC |
		boxC := (RSBox new extent: n*6@n;color: Color lightGreen; x:j*(n*9)+(n*1.5); y:i*(n*3)+n).
		labelC := (RSLabel new text: 0; x:j*(n*9)+(n*1.5); y:i*(n*3)+n; fontSize: n/2).
		canvas addShape: boxC.
		canvas add: labelC.
		(labelsC at: i) add: labelC.
	].
].
]

{ #category : #private }
MatrixVisualisation >> createShapesProcess [
	shapesProcess := OrderedCollection new.
	1 to: p do: [ : i |
		| x y process |
		y := (i - 1) // pSqrt * pSize.
      x := (i - 1) % pSqrt * pSize.
		process := (RSBox new extent: (n*9*pSize)@(n*3*pSize);border: (RSBorder new width: 0); color: Color white; x:n*6+(x*n*9)+(n*9*pSize/2); y:n*2+(y*n*3)+(n*3*pSize/2)).
		canvas addShape: process.
		shapesProcess add: process
].
]

{ #category : #private }
MatrixVisualisation >> loadData: aFileName [ 
	| dict |
	dict := (NeoJSONReader on: (aFileName asFileReference) readStream)
	listClass: OrderedCollection;
   next.
	n := dict at:#n.
	a := dict at:#a.
	b := dict at:#b.
	c := dict at:#c.
	p := dict at:#p.
	pSize := dict at:#p_size.
	pSqrt := dict at:#p_sqrt.
	s := 0.
	1 to: n do: [ :i |
		s := (s + i - 1)
	].
]

{ #category : #private }
MatrixVisualisation >> loopC: v [
	| labelC step |
	step := 1.
	labelC := ((labelsC at: v i) at: v j).
	labelC text: (((c at: v i) at: v j) at: step).
	canvas newAnimation repeat
		loops: (n - 1);
   		duration: (2*(n*0.2+1.10)) seconds;
   		when: RSAnimationLoopEvent do: [ :evt|
      labelC text: (((c at: v i) at: v j) at: (step := step + 1)). ]
]

{ #category : #'accessing - attributes' }
MatrixVisualisation >> n [
	^n
]

{ #category : #private }
MatrixVisualisation >> oneStepA: v [
	| boxA |
	boxA := ((shapesA at: v i) at: v j).
	canvas newAnimation 
		duration: ((n*0.2)+1) seconds;
		from: boxA position;
		to: boxA position x - (n*9)@ boxA position y;
		on: boxA set: #position:;
		when: RSAnimationEndEvent 
		do: [ 
			v phase = 1
				ifTrue: [ 
					v vj: v vj - 1.  
					v moves: v moves - 1. 
					v moves > -1
						ifTrue: [
							v vj = 1 
								ifTrue: [ 
									self threeStepsAFirst: v 
								]
								ifFalse: [ 
									self oneStepA: v 
								].
						]
						ifFalse: [ 
							v secondWait: v secondWait - 1. 
							self waitA: v
						].
				]
				ifFalse: [ 
					v moves = n
						ifFalse: [ v vj: v vj - 1. self waitA: v ]. 
				]
			
		].
]

{ #category : #private }
MatrixVisualisation >> oneStepALabels: v [
	| labelA |
	labelA := ((labelsA at: v i) at: v j).
	canvas newAnimation 
		duration: ((n*0.2)+1) seconds;
		from: labelA position;
		to: labelA position x - (n*9)@ labelA position y;
		on: labelA set: #position:;
		when: RSAnimationEndEvent 
		do: [ 
			v phase = 1
				ifTrue: [ 
					v vj: v vj - 1.
					v moves: v moves - 1. 
					v moves > -1
						ifTrue: [ 
							v vj = 1
								ifTrue: [ 
									self threeStepsAFirstLabels: v 
								]
								ifFalse: [  
									self oneStepALabels: v 
								].
						]
						ifFalse: [ 
							v secondWait: v secondWait - 1. 
							self waitALabels: v
						].
				]
				ifFalse: [ 
					v moves = n
						ifFalse: [ v vj: v vj - 1. self waitALabels: v ]. 
				]
		].
]

{ #category : #private }
MatrixVisualisation >> oneStepB: v [
	| boxB |
	boxB := ((shapesB at: v i) at: v j).
	canvas newAnimation 
		duration: ((n*0.2)+1) seconds;
		from: boxB position;
		to: boxB position x + (n*3)@ boxB position y - (n*3);
		on: boxB set: #position:;
		when: RSAnimationEndEvent 
		do: [ 
			v phase = 1
				ifTrue: [ 
					v vi: v vi - 1.
					v moves: v moves - 1. 
					v moves > -1
						ifTrue: [
							v vi = 1 
								ifTrue: [ 
									self threeStepsBFirst: v 
								]
								ifFalse: [ 
									self oneStepB: v 
								].
						]
						ifFalse: [ 
							v secondWait: v secondWait - 1.
							self waitB: v
						].
				]
				ifFalse: [ 
					v moves = n
						ifFalse: [ v vi: v vi - 1. self waitB: v ]. 
				]
		].
]

{ #category : #private }
MatrixVisualisation >> oneStepBLabels: v [
	| labelB |
	labelB := ((labelsB at: v i) at: v j).
	canvas newAnimation 
		duration: ((n*0.2)+1) seconds;
		from: labelB position;
		to: labelB position x + (n*3)@ labelB position y - (n*3);
		on: labelB set: #position:;
		when: RSAnimationEndEvent 
		do: [ 
			v phase = 1
				ifTrue: [ 
					v vi: v vi - 1.
					v moves: v moves - 1. 
					v moves > -1
						ifTrue: [ 
							v vi = 1
								ifTrue: [ 
									self threeStepsBFirstLabels: v 
								]
								ifFalse: [  
									self oneStepBLabels: v 
								].
						]
						ifFalse: [ 
							v secondWait: v secondWait - 1.
							self waitBLabels: v
						].
				]
				ifFalse: [ 
					v moves = n
						ifFalse: [ v vi: v vi - 1. self waitBLabels: v ]. 
				]
		].
]

{ #category : #'accessing - attributes' }
MatrixVisualisation >> p [
	^p
]

{ #category : #'accessing - attributes' }
MatrixVisualisation >> pSize [
	^pSize
]

{ #category : #'accessing - attributes' }
MatrixVisualisation >> pSqrt [
	^pSqrt
]

{ #category : #private }
MatrixVisualisation >> processAnimation [
	1 to: p do: [ :i |
		| pShape |
		pShape := (shapesProcess at: i).
		canvas newAnimation 
			from: 0;
			to: 0.5;
			on: pShape border set: 'width:'.
	].
]

{ #category : #'accessing - attributes' }
MatrixVisualisation >> s [
	^s
]

{ #category : #'action handling' }
MatrixVisualisation >> simulate: aFileName [ 
	self loadData: aFileName .
	self createShapesAndLabels.
	self addAnimations.
	^canvas
]

{ #category : #private }
MatrixVisualisation >> threeStepsAFirst: v [ 
	| boxA |
	boxA := ((shapesA at: v i) at: v j).
	canvas newAnimation 
		duration: 0.5 seconds;
		from: boxA position;
		to: boxA position x + n @ boxA position y - n;
		on: boxA set: #position:;
		when: RSAnimationEndEvent 
		do: [ self threeStepsASecond: v ].
]

{ #category : #private }
MatrixVisualisation >> threeStepsAFirstLabels: v [
	| labelA |
	labelA := ((labelsA at: v i) at: v j).
	canvas newAnimation 
		duration: 0.5 seconds;
		from: labelA position;
		to: labelA position x + n @ labelA position y - n;
		on: labelA set: #position:;
		when: RSAnimationEndEvent 
		do: [ self threeStepsASecondLabels: v ].
]

{ #category : #private }
MatrixVisualisation >> threeStepsASecond: v [ 
	| boxA |
	boxA := ((shapesA at: v i) at: v j).
	canvas newAnimation 
		duration: (n*0.2) seconds;
		from: boxA position;
		to: boxA position x+(n*9*(n-1))@ boxA position y;				
		on: boxA set: #position:;
		when: RSAnimationEndEvent 
		do: [ self threeStepsAThird: v ].
]

{ #category : #private }
MatrixVisualisation >> threeStepsASecondLabels: v [
	| labelA |
	labelA := ((labelsA at: v i) at: v j).
	canvas newAnimation 
		duration: (n*0.2) seconds;
		from: labelA position;
		to: labelA position x+(n*9*(n-1))@ labelA position y;				
		on: labelA set: #position:;
		when: RSAnimationEndEvent 
		do: [ self threeStepsAThirdLabels: v ].
]

{ #category : #private }
MatrixVisualisation >> threeStepsAThird: v [ 
	| boxA |
	boxA := ((shapesA at: v i) at: v j).
	canvas newAnimation 
		duration: 0.5 seconds;
		from: boxA position;
		to: boxA position x - n@ boxA position y + n;
		on: boxA set: #position:;
		when: RSAnimationEndEvent 
		do: [ 
			v phase = 1
				ifTrue: [ 
					v vj: n. 
					v moves: v moves - 1. 
					v moves > -1
						ifTrue: [  
							v vj = 1 
								ifTrue: [ self threeStepsAFirst: v ]
								ifFalse: [ self oneStepA: v ].
						]
						ifFalse: [ 
							v secondWait: v secondWait - 1. 
							self waitA: v
						].
				]
				ifFalse: [ 
					v moves = n
						ifFalse: [ v vj: n. self waitA: v ]. 
				].
		].
]

{ #category : #private }
MatrixVisualisation >> threeStepsAThirdLabels: v [
	| labelA |
	labelA := ((labelsA at: v i) at: v j).
	canvas newAnimation 
		duration: 0.5 seconds;
		from: labelA position;
		to: labelA position x - n@ labelA position y + n;
		on: labelA set: #position:;
		when: RSAnimationEndEvent 
		do: [ 
			v phase = 1
				ifTrue: [ 
					v vj: n.
					v moves: v moves - 1. 
					v moves > -1
						ifTrue: [  
							v vj = 1 
								ifTrue: [ self threeStepsAFirstLabels: v ]
								ifFalse: [ self oneStepALabels: v ].
						]
						ifFalse: [ 
							v secondWait: v secondWait - 1. 
							self waitALabels: v
						].
				]
				ifFalse: [ 
					v moves = n
						ifFalse: [ v vj: n. self waitALabels: v ]. 
				].
		].
]

{ #category : #private }
MatrixVisualisation >> threeStepsBFirst: v [
	| boxB |
	boxB := ((shapesB at: v i) at: v j).
	canvas newAnimation 
		duration: 0.5 seconds;
		from: boxB position;
		to: boxB position x + (n*3)@ boxB position y;
		on: boxB set: #position:;
		when: RSAnimationEndEvent 
		do: [ self threeStepsBSecond: v ].
]

{ #category : #private }
MatrixVisualisation >> threeStepsBFirstLabels: v [
	| labelB |
	labelB := ((labelsB at: v i) at: v j).
	canvas newAnimation 
		duration: 0.5 seconds;
		from: labelB position;
		to: labelB position x + (n*3)@ labelB position y;
		on: labelB set: #position:;
		when: RSAnimationEndEvent 
		do: [ self threeStepsBSecondLabels: v ].
]

{ #category : #private }
MatrixVisualisation >> threeStepsBSecond: v [
	| boxB |
	boxB := ((shapesB at: v i) at: v j).
	canvas newAnimation 
		duration: (n*0.2) seconds;
		from: boxB position;
		to: boxB position x-(n*3*(n-1))@ boxB position y + (n*3*(n-1));				
		on: boxB set: #position:;
		when: RSAnimationEndEvent 
		do: [ self threeStepsBThird: v ].
]

{ #category : #private }
MatrixVisualisation >> threeStepsBSecondLabels: v [
	| labelB |
	labelB := ((labelsB at: v i) at: v j).
	canvas newAnimation 
		duration: (n*0.2) seconds;
		from: labelB position;
		to: labelB position x-(n*3*(n-1))@ labelB position y + (n*3*(n-1));				
		on: labelB set: #position:;
		when: RSAnimationEndEvent 
		do: [ self threeStepsBThirdLabels: v ].
]

{ #category : #private }
MatrixVisualisation >> threeStepsBThird: v [
	| boxB |
	boxB := ((shapesB at: v i) at: v j).
	canvas newAnimation 
		duration: 0.5 seconds;
		from: boxB position;
		to: boxB position x - (n*3)@ boxB position y;
		on: boxB set: #position:;
		when: RSAnimationEndEvent 
		do: [ 
			v phase = 1
				ifTrue: [ 
					v vi: n. 
					v moves: v moves - 1.
					v moves > -1
						ifTrue: [ 
							v vi = 1 
								ifTrue: [ self threeStepsBFirst: v ]
								ifFalse: [ self oneStepB: v ].
						]
						ifFalse: [ 
							v secondWait: v secondWait - 1. 
							self waitB: v
						].
				]
				ifFalse: [ 
					v moves = n
						ifFalse: [ v vi: n. self waitB: v ]. 
				].
		].
]

{ #category : #private }
MatrixVisualisation >> threeStepsBThirdLabels: v [
	| labelB |
	labelB := ((labelsB at: v i) at: v j).
	canvas newAnimation 
		duration: 0.5 seconds;
		from: labelB position;
		to: labelB position x - (n*3)@ labelB position y;
		on: labelB set: #position:;
		when: RSAnimationEndEvent 
		do: [ 
			v phase = 1
				ifTrue: [ 
					v vi: n. 
					v moves: v moves - 1. 
					v moves > -1
						ifTrue: [
							v vi = 1 
								ifTrue: [ self threeStepsBFirstLabels: v ]
								ifFalse: [ self oneStepBLabels: v ].
						]
						ifFalse: [ 
							v secondWait: v secondWait - 1.
							self waitBLabels: v
						].
				]
				ifFalse: [ 
					v moves = n
						ifFalse: [ v vi: n. self waitBLabels: v ]. 
				].
		].
]

{ #category : #private }
MatrixVisualisation >> waitA: v [
	canvas newAnimation 
		duration: (n * 0.2 + 1) seconds;
		when: RSAnimationEndEvent
		do: [ 
			v phase = 1
				ifTrue: [ 
					v firstWait > 0
						ifTrue: [ v firstWait: v firstWait - 1. self waitA: v ]
						ifFalse: [  
							v moves > 0
								ifTrue: [  
									v moves: v moves - 1. 
									v vj = 1 
										ifTrue: [ 
											self threeStepsAFirst: v 
										]
										ifFalse: [ 
											self oneStepA: v 
										].
								]
								ifFalse: [ 
									v secondWait > 0
										ifTrue: [ 
											v secondWait: v secondWait - 1. 
											self waitA: v 
										]
										ifFalse: [ 
											v moves: 2.
											v phase: 2.
											v vj = 1 
												ifTrue: [ self threeStepsAFirst: v ]
												ifFalse: [ self oneStepA: v ].
										].
								].
						].
				]
				ifFalse: [  
					v moves: v moves + 1.
					v vj = 1
						ifTrue: [ self threeStepsAFirst: v ]
						ifFalse: [ self oneStepA: v ].
				].
			
		]. 	 
]

{ #category : #private }
MatrixVisualisation >> waitALabels: v [
	canvas newAnimation 
		duration: (n * 0.2 + 1) seconds;
		when: RSAnimationEndEvent
		do: [ 
			v phase = 1
				ifTrue: [ 
					v firstWait > 0
						ifTrue: [ v firstWait: v firstWait - 1. self waitALabels: v ]
						ifFalse: [  
							v moves > 0
								ifTrue: [ 
									v moves: v moves - 1.  
									v vj = 1 
										ifTrue: [ 
											self threeStepsAFirstLabels: v 
										]
										ifFalse: [ 
											self oneStepALabels: v 
										].
								]
								ifFalse: [ 
									v secondWait > 0
										ifTrue: [ 
											v secondWait: v secondWait - 1. 
											self waitALabels: v 
										]
										ifFalse: [ 
											v moves: 2.
											v phase: 2.
											self processAnimation.
											self loopC: (Visualisation  new i: v i; j: v j).
											v vj = 1 
												ifTrue: [ self threeStepsAFirstLabels: v ]
												ifFalse: [ self oneStepALabels: v ].
											
										].
								].
						].
				]
				ifFalse: [
					v moves: v moves + 1.  
					v vj = 1
						ifTrue: [ self threeStepsAFirstLabels: v ]
						ifFalse: [ self oneStepALabels: v ].
				].
			
		]. 	 
]

{ #category : #private }
MatrixVisualisation >> waitB: v [
	canvas newAnimation
		duration: (n * 0.2 + 1) seconds;
		when: RSAnimationEndEvent
			do: [ v phase = 1
				ifTrue: [ v firstWait > 0
						ifTrue: [ v firstWait: v firstWait - 1.
							self waitB: v ]
						ifFalse: [ v moves > 0
								ifTrue: [ v moves: v moves - 1.
									v vi = 1
										ifTrue: [ self threeStepsBFirst: v ]
										ifFalse: [ self oneStepB: v ] ]
								ifFalse: [ v secondWait > 0
										ifTrue: [ v secondWait: v secondWait - 1.
											self waitB: v ]
										ifFalse: [ v moves: 2.
											v phase: 2.
											v vi = 1
												ifTrue: [ self threeStepsBFirst: v ]
												ifFalse: [ self oneStepB: v ] ] ] ] ]
				ifFalse: [ v moves: v moves + 1.
					v vi = 1
						ifTrue: [ self threeStepsBFirst: v ]
						ifFalse: [ self oneStepB: v ] ] ]
]

{ #category : #private }
MatrixVisualisation >> waitBLabels: v [
	canvas newAnimation
		duration: (n * 0.2 + 1) seconds;
		when: RSAnimationEndEvent
			do: [ v phase = 1
				ifTrue: [ v firstWait > 0
						ifTrue: [ v firstWait: v firstWait - 1.
							self waitBLabels: v ]
						ifFalse: [ v moves > 0
								ifTrue: [ v moves: v moves - 1.
									v vi = 1
										ifTrue: [ self threeStepsBFirstLabels: v ]
										ifFalse: [ self oneStepBLabels: v ] ]
								ifFalse: [ v secondWait > 0
										ifTrue: [ v secondWait: v secondWait - 1.
											self waitBLabels: v ]
										ifFalse: [ v moves: 2.
											v phase: 2.
											v vi = 1
												ifTrue: [ self threeStepsBFirstLabels: v ]
												ifFalse: [ self oneStepBLabels: v ] ] ] ] ]
				ifFalse: [ v moves: v moves + 1.
					v vi = 1
						ifTrue: [ self threeStepsBFirstLabels: v ]
						ifFalse: [ self oneStepBLabels: v ] ] ]
]
