"
Comment
"
Class {
	#name : #Visualisation,
	#superclass : #Object,
	#instVars : [
		'firstWait',
		'i',
		'j',
		'moves',
		'phase',
		'secondWait',
		'vi',
		'vj'
	],
	#category : #CannonsMMVisualisation
}

{ #category : #'accessing - attributes' }
Visualisation >> firstWait [
	^firstWait
]

{ #category : #'accessing - attributes' }
Visualisation >> firstWait: aFirstWait [
	firstWait := aFirstWait 
]

{ #category : #'accessing - attributes' }
Visualisation >> i [
	^i
]

{ #category : #'accessing - attributes' }
Visualisation >> i: aI [
	i := aI
]

{ #category : #'accessing - attributes' }
Visualisation >> j [
	^j
]

{ #category : #'accessing - attributes' }
Visualisation >> j: aJ [
	j := aJ
]

{ #category : #'accessing - attributes' }
Visualisation >> moves [
	^moves
]

{ #category : #'accessing - attributes' }
Visualisation >> moves: aMoves [
	moves := aMoves 
]

{ #category : #'accessing - attributes' }
Visualisation >> phase [
	^phase
]

{ #category : #'accessing - attributes' }
Visualisation >> phase: aPhase [
	phase := aPhase < 2
		ifTrue: [ 1 ]
		ifFalse: [ 2 ]
]

{ #category : #'accessing - attributes' }
Visualisation >> secondWait [
	^secondWait
]

{ #category : #'accessing - attributes' }
Visualisation >> secondWait: aSecondWait [
	secondWait := aSecondWait 
		
]

{ #category : #'accessing - attributes' }
Visualisation >> vi [
	^vi
]

{ #category : #'accessing - attributes' }
Visualisation >> vi: aVi [
	vi := aVi 
		
]

{ #category : #'accessing - attributes' }
Visualisation >> vj [
	^vj
]

{ #category : #'accessing - attributes' }
Visualisation >> vj: aVj [
	vj := aVj 
		
]
