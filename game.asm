# Bitmap display starter code
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 512
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
.eqv BASE_ADDRESS 0x10008000
.eqv BASE_PLAYER_SPEED_X 17
.eqv DASH_COLOR 0x29bbf2
.eqv BACKGROUND_COLOR 0x10101d

.data

	#Game Setup
	gameState: .word 0
	
	frameDelay: .word 1
	
	level: .word 0:4096
	
	#flag 4 by 5
	flagSprite: .word 0x864920,0xBB4444,0xD95959,0xD95959,0x864920,0xBB4444,0xD95959,0xD95959,0x864920,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0x864920,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0x6E3915,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR
	flagPos: .word 0
	nextState: .word 1
	
	#Items
	#---------------------------------------------------------------------------------------------------------------------
	#Spike Data
	spikeSprite: .word BACKGROUND_COLOR, 0xdadada, BACKGROUND_COLOR, BACKGROUND_COLOR, 0xc6c6c6, BACKGROUND_COLOR, 0xb2b2b2, 0xb2b2b2, 0xb2b2b2
	numSpikes: .word 0
	spikeArray: .word 0:40 #position, count
	
	#Crystal Data
	crystalSprite: .word BACKGROUND_COLOR, 0xd4f9bc, BACKGROUND_COLOR, 0xaadc89, 0x6ad524, 0xd4f9bc, BACKGROUND_COLOR, 0xaadc89, BACKGROUND_COLOR
	numCrystals: .word 0
	crystalArray: .word 0:16 # position, isActive, coolDown, coolDownTimer
	
	#Purple Crystal
	purpleCrystalSprite: .word BACKGROUND_COLOR, 0xfc83c7, BACKGROUND_COLOR, 0xc15692, 0xaa5ec3, 0xfc83c7, BACKGROUND_COLOR, 0xc15692, BACKGROUND_COLOR
	purpleCrystalPos: .word -1
	purplePlatsNum: .word 0
	purplePlatsArray: .word 0:20 #position, width, height, nothing
	
	#Strawberry
	strawberrySprite: .word BACKGROUND_COLOR, 0x3eca6b, 0x98eb77, BACKGROUND_COLOR, 0xbb4444, 0xd95959, 0xd95959, 0xd95959, 0xbb4444, 0xbb4444, 0xd95959, 0xd95959, BACKGROUND_COLOR, 0xbb4444, 0xbb4444, BACKGROUND_COLOR
	strawberryPos: .word -1
	
	#Player Data
	#-------------------------------------------------------------------------------------
	#Player Data
	playerPos: .word 1000
	playerPrevPos: .word 0 #Used for temp variable storage
	
	playerSpeedX: .word 17 # How many frames per update
	playerSpeedY: .word 10 # How many frames per update
		
	playerVelX: .word 0
	playerVelY: .word 0
	
	isGrounded: .word 0
	jumping: .word 0
	
	dashing: .word 0
	canDash: .word 1
	dashCooldown: .word 1000
	
	facingLeft: .word 0
	
	strawberryCount: .word 0
	hasStrawberry: .word 0
	
	#Player Sprite
	sprite: .word BACKGROUND_COLOR, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd7bb1eb, 0xd7bb1eb, 0xd95959, 0xd95959, 0xd95959, 0xd95959, BACKGROUND_COLOR, 0xd95959, BACKGROUND_COLOR, 0xd95959
	leftSprite: .word 0xd95959, 0xd95959, 0xd95959, BACKGROUND_COLOR, 0xd7bb1eb, 0xd7bb1eb, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd000000 0xd95959, 0xd000000
	dashSprite: .word BACKGROUND_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, 0xd7bb1eb, 0xd7bb1eb, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, BACKGROUND_COLOR, DASH_COLOR, BACKGROUND_COLOR, DASH_COLOR
	leftDashSprite: .word DASH_COLOR, DASH_COLOR, DASH_COLOR, BACKGROUND_COLOR, 0xd7bb1eb, 0xd7bb1eb, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, 0xd000000 DASH_COLOR, 0xd000000
	spriteSizeX: .word 4
	spriteSizeY: .word 7
	#-------------------------------------------------------------------------------------
	
	#Start Menu
	ready: .word BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR
	start: .word BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR
	exit:  .word 0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR
	selection: .word 0	
	
	#EndScreen:  number starts at 2341
	youWin: .word 0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF
	BerryX: .word BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0x3ECA6B,0x98EB77,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xBB4444,0xD95959,0xD95959,0xD95959,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xBB4444,0xBB4444,0xD95959,0xD95959,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xBB4444,0xBB4444,BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF
	#numbers
	zero: .word 0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF
	one: .word 0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF
	two: .word 0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF
	three: .word 0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF
	four: .word 0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF,BACKGROUND_COLOR,BACKGROUND_COLOR,0xFFFFFF
	
	#Random Crap
	newline: .asciiz "\n"
	
.globl main
.text
main: 
    # Continue with the rest of your code here

	li $t0, BASE_ADDRESS # possition of our painting brush
	li $t1, BACKGROUND_COLOR #stores the color black (for clearing pixels)
	
	#Load in frame buffer values
	li $s7, 0
	li $s6, 0
	
	#Jump Frame AC
	li $s5, 0
	
	#Dash time AC
	li $s4, 0
	
	jal resetState 

	
update: 

	lw $t8, gameState
	beq $t8, $zero skipUpdatesCuzWeOnTheStartMenuHommy

	jal FlagUpdate
	jal purpleCrystalUpdate
	jal strawberryUpdate
	jal spikeUpdate
	jal crystalUpdate
	jal updatePlayer
	
	j menuSkip
	
	skipUpdatesCuzWeOnTheStartMenuHommy:
	jal startScreenUpdate
	
	menuSkip:
	#sleep command
	la $v0, 32
	lw $a0, frameDelay
	syscall
	
	#Get user input
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, keyPressed	 
	

	j update

#closing the game
end:
	li $v0, 10
	syscall


#Handle User input
keyPressed:
	lw $t2, 4($t9) 
	beq $t2, 0x61, aPress
	beq $t2, 0x77, wPress 
	beq $t2, 0x64, dPress 
	beq $t2, 0x73, sPress
	beq $t2, 0x6A, jPress  
	beq $t2, 0x6B, kPress #dash button
	beq $t2, 0x70, pPress    
	
	
	j update
	
	aPress: 
		sw $zero, selection
	
		#Can't momentum cancel if dashing
		lw $t9, dashing
		bne $t9, $zero, update
	
		
	
		li $t5, -1
		sw $t5, playerVelX
		j update
		
	#Jumping buttons
	jPress:
	wPress: 
		#Can't jump if not grounded
		lw $t9, isGrounded
		beq $t9, $zero, update
		
		#Can't jump if dashing
		lw $t9, dashing
		bne $t9, $zero, update
		
		li $t7, -1
		sw $t7, playerVelY
		
		li $t7, 3
		sw $t7, playerSpeedY
		
		li $t5, 0
		sw $t5, isGrounded
		li $t5, 1
		sw $t5, jumping
		j update
	dPress: 
		li $t8, 1
		sw $t8, selection
	
		#Can't momentum cancel if dashing
		lw $t9, dashing
		bne $t9, $zero, update
	
		li $t5, 1
		sw $t5, playerVelX
		j update
		
	sPress: 
		lw $t8, gameState
		beq $t8, $zero, startMenuSubmit
	
		#Can't momentum cancel if dashing
		lw $t9, dashing
		bne $t9, $zero, update
		
		li $t5, 0
		sw $t5, playerVelX
		j update
		
		startMenuSubmit:
			lw $t8, selection
			beq $t8, $zero, startGame
			j end
						
			startGame:
			addi $sp, $sp, -4
			sw $ra, ($sp)
										
    			lw $t9, nextState
    			sw $t9, gameState
    			jal resetState   
    			
    			
    						
			lw $ra, ($sp)
    			addi $sp, $sp, 4 
				
		
	pPress: 
		jal resetState
		j update
	
	#Dash Button	
	kPress:
		lw $t9, canDash
		beq $t9, $zero, update
		li $t5, 1
		sw $t5, dashing
		sw $zero, canDash
		j update


#Update both player position and sprite position on screen
updatePlayer:	
	#Dash Logic
	lw $t9, dashing
	beq $t9, $zero, playerIsNotDashing 
	
	sw $zero playerVelY
	
	addi $s4, $s4, 1
	
	#Set Dash Direction
	lw $t8, facingLeft
	beq $t8, $zero, dashRight
	dashLeft:
		li $t8, -1
		sw $t8, playerVelX
		j setSpeed
	dashRight:
		li $t8, 1
		sw $t8, playerVelX
	
	#Set Dash speed
	setSpeed:
		li $t8, 2
		sw $t8, playerSpeedX
	
	#Check if the dash is over	
	li $t9, 30
	bgt $s4, $t9, finishedDash
	j continueToPosUpdate
	
	finishedDash:
			
		li $s4, 0
		
		sw $zero, dashing
		
		li $t8, BASE_PLAYER_SPEED_X
		sw $t8, playerSpeedX
		
	
	
	playerIsNotDashing:
	li $t8, BASE_PLAYER_SPEED_X
	sw $t8, playerSpeedX
	
	li $s4, 0
	sw $zero, dashing
	
	#Update Player State
	lw $t9, jumping
	lw $t8, isGrounded
	
	#Check if jump is true
	beq $t9, $zero, checkGrounded

	#Jumping Logic
	#--------------------------------------------------------------
	#jumping is true	
	addi $s5, $s5, 1
	li $t7, 12
	bgt $s5, $t7, decreaseYSpeed
	j continueToPosUpdate
	
	decreaseYSpeed:
	#decrease speed as player jumps (to mimik gravity)
	li $s5, 0
	lw $t7, playerSpeedY
	addi $t7, $t7, 3
	sw $t7, playerSpeedY
	li $t6, 45
	bgt $t7, $t6, transitionToFalling 
	j continueToPosUpdate
	
	#Go from jumping to falling
	transitionToFalling:
	li $t7, 0
	sw $t7, jumping
	
	j continueToPosUpdate
	
	#Falling Logic
	#------------------------------------------------------------
	checkGrounded:
	bne $t8, $zero, continueToPosUpdate

	#Plyaer is not grounded and not jumping
	li $t7, 1
	sw $t7, playerVelY
	
	addi $s5, $s5, 1
	li $t7, 5
	bgt $s5, $t7, increaseFallSpeed
	j continueToPosUpdate
	
	increaseFallSpeed:
	#decrease speed as player jumps (to mimik gravity)
	lw $t7, playerSpeedY
	li $s5, 0
	li $t6, 10
	blt $t7, $t6, continueToPosUpdate 
	addi $t7, $t7, -5
	sw $t7, playerSpeedY
	

	j continueToPosUpdate

	#Player Position update 
	#-------------------------------------------------------------
	continueToPosUpdate:
	
	#Get velocity
	lw $t7, playerVelX
	lw $t8, playerVelY
	
	#Flip Player Sprite
	beq $t7, $zero, skipflipLeft
	blt $t7, $zero, flipPlayerLeft
	li $t2, 0
	sw $t2, facingLeft
	j skipflipLeft
		
	flipPlayerLeft:
		li $t2, 1
		sw $t2, facingLeft
	
	skipflipLeft:
	
	#Check if player is moving
	bne $t7, $zero, doPlayerUpdate
	bne $t8, $zero, doPlayerUpdate
	#if player isn't moving, then don't update
	j finishedPlayerUpdate
	
	
	doPlayerUpdate:
	#Get Current Position
	lw $t9, playerPos
	sw $t9, playerPrevPos
	#-------------------------------------------------------------
	#update playerUpdateCounter and see if we can update the player
	addi $s6, $s6,  1
	lw $t6, playerSpeedX
	bgt $s6, $t6, doXUpdate
	j checkYUpdate
	
	doXUpdate:
		#if velocity is zero, skip update
		beq $t7, $zero, skipXUpdate
		li $s6, 0 # Reset counter
		
		#Wall Collision Check
		li $t6, 64
		div $t9, $t6
		mfhi $t4 #current x
		add $t4, $t4, $t7
		li $t6, 0
		blt $t4, $t6, playerWallHit
		li $t6, 60
		bgt $t4, $t6, playerWallHit
		
		la $t6, level		
		add $t4, $t9, $t7
		sll $t5, $t4, 2
		add $t6, $t6, $t5
		lw $t5, 0($t6)
		bgt $t5, $zero, playerWallHit
				
		addi $t6, $t6, 12	
		lw $t5, 0($t6)			
		bgt $t5, $zero, playerWallHit
		
		addi $t6, $t6, 256
		lw $t5, 0($t6)			
		bgt $t5, $zero, playerWallHit
		
		addi $t6, $t6, 256
		lw $t5, 0($t6)			
		bgt $t5, $zero, playerWallHit
		
		addi $t6, $t6, 256
		lw $t5, 0($t6)			
		bgt $t5, $zero, playerWallHit
		
		addi $t6, $t6, -12	
		lw $t5, 0($t6)			
		bgt $t5, $zero, playerWallHit
		
		addi $t6, $t6, -256
		lw $t5, 0($t6)			
		bgt $t5, $zero, playerWallHit
		
		addi $t6, $t6, -256
		lw $t5, 0($t6)			
		bgt $t5, $zero, playerWallHit
		
		addi $t6, $t6, -256
		lw $t5, 0($t6)			
		bgt $t5, $zero, playerWallHit
		
		j normalXUpdate
		
		playerWallHit:
			lw $t4, playerVelX
			sub $t4, $zero, $t4
			add $t9, $t9, $t4
			sw $t4, playerVelX
			sw $zero playerVelX
			sw $zero dashing
		
		#Update player position x
		normalXUpdate:
		add $t9, $t9, $t7
		j checkYUpdate
		
		skipXUpdate:
			li $s6, 1 # Reset counter
	
	#update playerUpdateCounter and see if we can update the player
	checkYUpdate:
	addi $s7, $s7,  1
	lw $t6, playerSpeedY
	bgt $s7, $t6, doYUpdate
	j checkDraw
	
	doYUpdate:
		#if velocity is zero, skip update
		#beq $t8, $zero, skipYUpdate
		li $s7, 0 # Reset counter
		
		#Ground Collision Check
		move $t6, $t8
		sll $t6, $t6, 6
		
		#top
		add $t5, $t6, $t9
		la $t6, level
		sll $t4, $t5, 2
		add $t6, $t6, $t4
		lw $t4, ($t6)
		bgt $t4, $zero, cancelJump
		addi $t6, $t6, 12
		lw $t4, ($t6)
		bgt $t4, $zero, cancelJump
		
		#Bot
		addi $t4, $t5, 256
		li $t6, 4096
		bgt $t4, $t6, grounded
		
		la $t6, level
		sll $t4, $t4, 2
		
		add $t6, $t6, $t4
		lw $t4, ($t6)
		bgt $t4, $zero, grounded
		
		
		addi $t6, $t6, 4
		lw $t4, ($t6)
		bgt $t4, $zero, grounded
		
		addi $t6, $t6, 4
		lw $t4, ($t6)
		bgt $t4, $zero, grounded
		
		addi $t6, $t6, 4
		lw $t4, ($t6)
		bgt $t4, $zero, grounded
		j notGrounded
		
		#Turn off Jump
		cancelJump:
		sw $zero, jumping
		j checkDraw
		
		#Set player to gounded state
		grounded:
		li $t6, 1
		sw $t6, isGrounded
		
		li $s5, 0
		
		sw $zero, playerVelY
		move $t6, $t8
		sll $t6 $t6, 6
		add $t9, $t9, $t6
		
		lw $t6, dashing
		bne $t6, $zero, checkDraw
		li $t6, 1
		sw $t6, canDash
		j checkDraw
		
		#Update player position y	
		notGrounded:
		sw $zero, isGrounded
		move $t6, $t8
		sll $t6 $t6, 6
		add $t9, $t9, $t6

		
		j checkDraw
		
		skipYUpdate:
			li $s7, 1 # Reset counter
	#-------------------------------------------------------------	
	#Check to see if the player has moved
	checkDraw:
		bne $s6, $zero, nextCheck
		j doPlayerSpriteUpdate
		nextCheck: bne $s7, $zero,finishedPlayerUpdate 
		
	doPlayerSpriteUpdate:
	#Store new position
	sw $t9, playerPos
	
	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
	
	playerSpriteLoopY:
		beq $t4, 4, endOfplayerSpriteLoopY
		li $t5, 0
		playerSpriteLoopX:
			beq $t5, 4, endOfplayerSpriteLoopX
			#Calculate postiion of new sprite pixel relative to new position
			move $t6, $t5
			move $t3, $t4
			sll $t3, $t3, 6
			add $t6, $t6, $t3

			#Set a1 to screen position
			add $a1, $t6, $t9
			
			#Get reference sprite
			la $t3, sprite
			
			lw $s0, facingLeft
			bgt $s0, $zero, playerFacingLeft
			j playerFacingRight
			
			#Player is facing left
			playerFacingLeft:
			lw $s0, canDash
			beq $s0, $zero, leftCantDash
			leftCanDash:
				la $t3, leftSprite
			j drawPlayerPixel
			leftCantDash:
				la $t3, leftDashSprite
			j drawPlayerPixel
			
			#Player is facing right
			playerFacingRight:
			lw $s0, canDash
			beq $s0, $zero, rightCantDash
			rightCanDash:
				la $t3, sprite
			j drawPlayerPixel
			rightCantDash:
				la $t3, dashSprite
			j drawPlayerPixel
			
			drawPlayerPixel:
			#Get color of pixel
			move $t2, $t4
			sll $t2, $t2, 2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
#--------------------------------------------------------------------------------
			#Now we need to check from the old position to see which pixels we need to clear
			lw $t3, playerPrevPos
			add $t6, $t6, $t3
			
			#Compare the x pos of new and col cords
			li $t7, 64
			#X of old cord
			div $t6, $t7
			mfhi $t8
			#X of new cord
			div $t9, $t7
			mfhi $t7
			addi $t7, $t7, -1
			
			#Check if x cord is within the new sprite position 
			addi $t3, $t7, 5
			bge $t8, $t3, doClear
			ble $t8, $t7, doClear
			
			#Compare the y pos of new and col cords
			li $t7, 64
			#Y of old cord
			div $t6, $t7
			mflo $t8
			#Y of new cord
			div $t9, $t7
			mflo $t7
			addi $t7, $t7, -1
			
			#Check if y cord is within the new sprite position 
			addi $t3, $t7, 5
			bge $t8, $t3, doClear
			ble $t8, $t7, doClear
			
			#If we reach here, it means we do not need to clear this pixel
			 j stepPlayerSpriteLoopX
			#Do the clearing of our old pixel
			doClear:
			move $a0, $t1
			move $a1, $t6
			la $a3, drawPixel
			jalr $a2, $a3
	
		stepPlayerSpriteLoopX:
			addi $t5, $t5, 1
			j playerSpriteLoopX
		endOfplayerSpriteLoopX:
			addi $t4, $t4, 1
			j playerSpriteLoopY
	endOfplayerSpriteLoopY:
		
	
	finishedPlayerUpdate: jr $ra

#Check to see if player is colliding with crystal
crystalUpdate:
	li $t2, 0
	
	crystalUpdateLoop:
		lw $t3, numCrystals
		bge $t2, $t3, endcrystalUpdateLoop
			
		move $t3, $t2
		sll $t3, $t3  4
		la $t4, crystalArray
		add $t3, $t4, $t3
		
		
		lw $t9, playerPos
		lw $t8, ($t3)
		beq $t8, $zero, noCrystalOverlap
		
		#Check if crystal is active
		lw $s0, 4($t3)
		beq $s0, $zero, inactiveCrystal
		
		li $t3, 64
		
		#Check x
		div $t9, $t3
		mfhi $t7 #cur x
		div $t8, $t3
		mfhi $t6 #cur x
		
		addi $t7, $t7, 3
		blt $t7, $t6, noCrystalOverlap
		addi $t7, $t7, -3
		addi $t6, $t6, 2
		blt $t6, $t7, noCrystalOverlap
		
		#Check y
		div $t9, $t3
		mflo $t7 #cur y
		div $t8, $t3
		mflo $t6 #cur y
		
		addi $t7, $t7, 3
		blt $t7, $t6, noCrystalOverlap
		addi $t7, $t7, -3
		addi $t6, $t6, 2
		blt $t6, $t7, noCrystalOverlap
		
		#Activate the crystal
		activateCrystal:
			addi $sp, $sp, -4
			sw $ra, ($sp)
			
			addi $sp, $sp, -4
			sw $t2, ($sp)
			
			li $t6, 1
			sw $t6, canDash
			
			#Set isActive to false
			move $t3, $t2
			sll $t3, $t3  4
			la $t4, crystalArray
			add $t3, $t4, $t3
			sw $zero, 4($t3)
			
			#Deactivate crystal visuals			
    			addi $sp, $sp, -4
    			sw $zero, ($sp)
    			
    			addi $sp, $sp, -4
    			lw $t8, ($t3)
    			sw $t8, ($sp)
    			
    			jal toggleCrystal
			
			lw $t2, ($sp)
    			addi $sp, $sp, 4
			
			lw $ra, ($sp)
    			addi $sp, $sp, 4
    			
    			j noCrystalOverlap
    	inactiveCrystal:
    		lw $t9, 12($t3)
    		addi $t9, $t9, 1
    		sw $t9, 12($t3)
    		li $t8, 500
    		bgt $t9, $t8, reactivateCrystal
    		j noCrystalOverlap
    		reactivateCrystal:
    			sw $zero, 12($t3) 
    		
    			addi $sp, $sp, -4
			sw $ra, ($sp)
			
			addi $sp, $sp, -4
			sw $t2, ($sp)
    		
    			li $t8, 1
    			sw $t8, 4($t3)
    			
    			addi $sp, $sp, -4
    			sw $t8, ($sp)
    			
    			addi $sp, $sp, -4
    			lw $t8, ($t3)
    			sw $t8, ($sp)
    			
    			jal toggleCrystal
    			
    			lw $t2, ($sp)
    			addi $sp, $sp, 4
    			
    			lw $ra, ($sp)
    			addi $sp, $sp, 4
    			
    		
	noCrystalOverlap:
		addi $t2,  $t2, 1
		j crystalUpdateLoop
	endcrystalUpdateLoop:
		jr $ra	
	
#Check to see if player is colliding with spikes
spikeUpdate:
	li $t2, 0
	
	spikeUpdateLoop:
		lw $t3, numSpikes
		bge $t2, $t3, endSpikeUpdateLoop
		
		move $t3, $t2
		sll $t3, $t3  3
		la $t4, spikeArray
		add $t3, $t4, $t3
		
		
		
		lw $t9, playerPos
		lw $t8, ($t3)
		beq $t8, $zero, noSpikeOverlap
		
		lw $s0, 4($t3)
		sll $s0, $s0, 2	
		
		li $t3, 64
		
		#Check x
		div $t9, $t3
		mfhi $t7 #cur x
		div $t8, $t3
		mfhi $t6 #cur  x
				
		addi $t7, $t7, 3
		blt $t7, $t6, noSpikeOverlap
		subi $t7, $t7, 3	
		add $t6, $t6, $s0
		blt $t6, $t7, noSpikeOverlap
		
		#Check y
		div $t9, $t3
		mflo $t7 #cur y
		div $t8, $t3
		mflo $t6 #cur y
		
		addi $t7, $t7, 3
		blt $t7, $t6, noSpikeOverlap
		addi $t7, $t7, -3
		addi $t6, $t6, 2
		blt $t6, $t7, noSpikeOverlap
		
		#Activate the crystal
		activateSpike:
			addi $sp, $sp, -4
			sw $ra, ($sp)
			
			jal resetState
			
			lw $ra, ($sp)
    			addi $sp, $sp, 4
    			
    			j noSpikeOverlap    			
    		
	noSpikeOverlap:
		addi $t2,  $t2, 1
		j spikeUpdateLoop
	endSpikeUpdateLoop:
		jr $ra
		
#Check to see if player is colliding with strawberry
strawberryUpdate:

		lw $t9, playerPos
		lw $t8, strawberryPos
		beq $t8, $zero, noStrawberryOverlap
		
		#Check if crystal is active
		lw $s0, strawberryPos
		blt  $s0, $zero, noStrawberryOverlap
		
		li $t3, 64
		
		#Check x
		div $t9, $t3
		mfhi $t7 #cur x
		div $t8, $t3
		mfhi $t6 #cur x
		
		addi $t7, $t7, 4
		blt $t7, $t6, noStrawberryOverlap
		addi $t7, $t7, -4
		addi $t6, $t6, 3
		blt $t6, $t7, noStrawberryOverlap
		
		#Check y
		div $t9, $t3
		mflo $t7 #cur y
		div $t8, $t3
		mflo $t6 #cur y
		
		addi $t7, $t7, 4
		blt $t7, $t6, noStrawberryOverlap
		addi $t7, $t7, -4
		addi $t6, $t6, 3
		blt $t6, $t7, noStrawberryOverlap
		
		#Activate the crystal
		activateStrawberry:
			addi $sp, $sp, -4
			sw $ra, ($sp)
			
			addi $sp, $sp, -4
			sw $t2, ($sp)
						
			li $s0, 1
			sw $s0, hasStrawberry
			
			#Deactivate crystal visuals			
    			addi $sp, $sp, -4
    			sw $zero, ($sp)
    			
    			addi $sp, $sp, -4
    			lw $t8, strawberryPos
    			sw $t8, ($sp)
    			
    			jal toggleStrawberry
    			
    			li $s0, -1
    			sw $s0, strawberryPos
			
			lw $t2, ($sp)
    			addi $sp, $sp, 4
			
			lw $ra, ($sp)
    			addi $sp, $sp, 4
    			
    			j noCrystalOverlap
    		noStrawberryOverlap:	
			jr $ra	

#Check to see if player is colliding with purple crystal
purpleCrystalUpdate:

		lw $t9, playerPos
		lw $t8, purpleCrystalPos
		beq $t8, $zero, noPurpleOverlap
		
		#Check if crystal is active
		lw $s0, purpleCrystalPos
		blt  $s0, $zero, noPurpleOverlap
		
		li $t3, 64
		
		#Check x
		div $t9, $t3
		mfhi $t7 #cur x
		div $t8, $t3
		mfhi $t6 #cur x
		
		addi $t7, $t7, 3
		blt $t7, $t6, noPurpleOverlap
		addi $t7, $t7, -3
		addi $t6, $t6, 2
		blt $t6, $t7, noPurpleOverlap
		
		#Check y
		div $t9, $t3
		mflo $t7 #cur y
		div $t8, $t3
		mflo $t6 #cur y
		
		addi $t7, $t7, 3
		blt $t7, $t6, noPurpleOverlap
		addi $t7, $t7, -3
		addi $t6, $t6, 2
		blt $t6, $t7, noPurpleOverlap
		
		#Activate the crystal
		activatePurple:
			addi $sp, $sp, -4
			sw $ra, ($sp)
					
			#Deactivate crystal visuals			
    			addi $sp, $sp, -4
    			sw $zero, ($sp)
    			
    			addi $sp, $sp, -4
    			lw $t8, purpleCrystalPos
    			sw $t8, ($sp)
    			
    			jal togglePurpleCrystal
    			
    			li $s0, -1
    			sw $s0, purpleCrystalPos
    			
    			#Turn off all purple platforms
    			la $t3, purplePlatsArray
    			li $t5, 0
    			purplePlatLoop:
    			    			
    				lw $t4, purplePlatsNum
    				bgt $t5, $t4, endPurplePlatLoop
    				
    				#mode
    				addi $sp, $sp, -4
    				sw $zero, ($sp)
    				
    				#height
    				addi $sp, $sp, -4
    				lw $t8, 8($t3)
    				sw $t8, ($sp)
    				
    				#width
    				addi $sp, $sp, -4
    				lw $t8, 4($t3)
    				sw $t8, ($sp)
    				
    				#position
    				addi $sp, $sp, -4
    				lw $t8, ($t3)
    				sw $t8, ($sp)
    			
    				jal togglePurplePlatform
    				
    				addi $t5, $t5, 1
    				addi $t3, $t3, 16
    				
    				j purplePlatLoop
    			
			endPurplePlatLoop:
			
			lw $ra, ($sp)
    			addi $sp, $sp, 4
    			
    			j noCrystalOverlap
    		noPurpleOverlap:	
			jr $ra	

#Flag Update
FlagUpdate:

		lw $t9, playerPos
		lw $t8, flagPos
		beq $t8, $zero, noFlagOverlap
			
		li $t3, 64
		
		#Check x
		div $t9, $t3
		mfhi $t7 #cur x
		div $t8, $t3
		mfhi $t6 #cur x
		
		addi $t7, $t7, 4
		blt $t7, $t6, noFlagOverlap
		addi $t7, $t7, -4
		addi $t6, $t6, 2
		blt $t6, $t7, noFlagOverlap
		
		#Check y
		div $t9, $t3
		mflo $t7 #cur y
		div $t8, $t3
		mflo $t6 #cur y
		
		addi $t7, $t7, 5
		blt $t7, $t6, noFlagOverlap
		addi $t7, $t7, -5
		addi $t6, $t6, 2
		blt $t6, $t7, noFlagOverlap
		
		#Activate the crystal
		activateFlag:
			addi $sp, $sp, -4
			sw $ra, ($sp)
				
			lw $t9, hasStrawberry
    			bgt $t9, $zero, incrementStrawberryCount
    			j noStrawberry
    			
    			incrementStrawberryCount:
    				lw $t8,strawberryCount
    				addi $t8, $t8, 1
    				sw $t8, strawberryCount
    				    			
    			noStrawberry:		
						
    			lw $t9, nextState
    			sw $t9, gameState
    			jal resetState   
    			
    			
    						
			lw $ra, ($sp)
    			addi $sp, $sp, 4

    		noFlagOverlap:	
			jr $ra

#Start Screen Update:
startScreenUpdate:
	li $t9, 2824 #Start curser pos
	li $t8, 2857 #Exit curser pos
	
	lw $t2, selection
	beq $t2, $zero, startSelected
	
	#Exit Selected
	li $a0, BACKGROUND_COLOR
	move $a1, $t9
	la $a3, drawPixel
	jalr $a2, $a3
	
	li $a0, 0xff0000
	move $a1, $t8
	la $a3, drawPixel
	jalr $a2, $a3
	
	jr $ra
	#Start Selected
	startSelected:
	li $a0, BACKGROUND_COLOR
	move $a1, $t8
	la $a3, drawPixel
	jalr $a2, $a3
	
	li $a0, 0xff0000
	move $a1, $t9
	la $a3, drawPixel
	jalr $a2, $a3
	
	jr $ra

#------------------------------------------------------------------------------------------------------------------------
#Utility functions

#Make Platform given color, postion, width, height, ra on the stack
makePlatform:
	#Get Height
	lw $t9, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get Width
	lw $t8, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get position
	lw $t7, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get color
	lw $t6, ($sp)
    	addi $sp, $sp, 4
    	
    	#Draw loop
    	li $t4, 0 #Track our Y 
	li $t5, 0 #Track our X 
	
	platformLoopY:
		beq $t4, $t9, endPlatformLoopY
		li $t5, 0
		platformLoopX:
			beq $t5, $t8, endPlatformLoopX
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t7
			
			#Update Level Array
			la $t2, level
			sll $s0, $t3, 2
			add $t2, $t2, $s0
			li $s0, 1
			sw $s0, ($t2)	

			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			move $a0, $t6
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
			
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j platformLoopX
			
		endPlatformLoopX:
			addi $t4, $t4, 1
			j platformLoopY
		
	endPlatformLoopY:    		
    		jr $ra	
	
#Make Crystal
makeCrystal:
	
	

	#Get x position
	lw $t9, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get y position
	lw $t8, ($sp)
    	addi $sp, $sp, 4
    	
    	#Calc Actual position
    	move $t7, $t8
    	sll $t7, $t7, 6
    	add $t7, $t7, $t9
    	
    	la $t2, crystalArray
    	lw $s0, numCrystals
    	sll $s0, $s0, 4
    	add $t2, $t2, $s0
    	
    	
    	sw $t7, ($t2)
    	
    	addi $t2, $t2, 4
    	li $t3, 1
    	sw $t3, ($t2)
    	addi $t2, $t2, 4
    	sw $zero, ($t2)
    	addi $t2, $t2, 4
    	sw $zero, ($t2)
    	
    	#Increment Crystal Count
	lw $t2, numCrystals
	addi $t2, $t2 ,1
	sw $t2, numCrystals

	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
	
	crystalSpriteLoopY:
		beq $t4, 3, endCrystalSpriteLoopY
		li $t5, 0
		crystalSpriteLoopX:
			beq $t5, 3, endCrystalSpriteLoopX
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t7
			
			#Update Level Array
			la $t2, level
			sll $s0, $t3, 2
			add $t2, $t2, $s0
			li $s0, -2
			sw $s0, ($t2)	

			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			#Get color of sprite 
			la $t3, crystalSprite

			move $t2, $t4
			li $s0, 3
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
			
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j crystalSpriteLoopX
			
		endCrystalSpriteLoopX:
			addi $t4, $t4, 1
			j crystalSpriteLoopY
		
	endCrystalSpriteLoopY:    		
    		jr $ra
    		
#Toggle Crystal Visuals: position, mode
toggleCrystal:
	#Get position
	lw $t7, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get mode
	lw $t8, ($sp)
    	addi $sp, $sp, 4

	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
	
	crystalSpriteLoopYb:
		beq $t4, 3, endCrystalSpriteLoopYb
		li $t5, 0
		crystalSpriteLoopXb:
			beq $t5, 3, endCrystalSpriteLoopXb
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t7
			
			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			la $t3, crystalSprite

			move $t2, $t4
			li $s0, 3
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
			
			#Earase or Draw?
			beq $t8, $zero, eatTheAss
			j doPixelToggle
			
			eatTheAss:move $a0, $t1
			
			
			doPixelToggle:
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j crystalSpriteLoopXb
			
		endCrystalSpriteLoopXb:
			addi $t4, $t4, 1
			j crystalSpriteLoopYb
		
	endCrystalSpriteLoopYb:    		
    		jr $ra	

#Make Platform given postion, count on the stack
makeSpikes:
	#Get count
	lw $t8, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get position
	lw $t7, ($sp)
    	addi $sp, $sp, 4
    	
    	lw $t9, numSpikes
    	
    	la $t2, spikeArray
    	sll $s0, $t9, 3
    	add $t2, $t2, $s0
    	
    	sw $t7, ($t2)
    	addi $t2, $t2, 4
    	sw $t8, ($t2)
    	
    	addi $t9, $t9 ,1
	sw $t9, numSpikes
    	
    	#Draw loop
    	li $t6, 0
   	spikeLoop:
   	beq $t6, $t8, endSpikeLoop
    	
    	li $t4, 0 #Track our Y 
	li $t5, 0 #Track our X 
	
	spikeLoopY:
		beq $t4, 3, endSpikeLoopY
		li $t5, 0
		spikeLoopX:
			beq $t5, 3, endSpikeLoopX
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t7

			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			la $t3, spikeSprite

			move $t2, $t4
			li $s0, 3
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
			
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j spikeLoopX
			
		endSpikeLoopX:
			addi $t4, $t4, 1
			j spikeLoopY
		
	endSpikeLoopY:    		
    		addi $t6, $t6, 1
    		addi $t7, $t7, 4
		j spikeLoop
	endSpikeLoop:
		jr $ra

#Toggle Strawberry Visuals: position, mode
toggleStrawberry:
	#Get position
	lw $t7, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get mode
	lw $t8, ($sp)
    	addi $sp, $sp, 4

	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
	
	sw $t7, strawberryPos
	
	strawberrySpriteLoopYb:
		beq $t4, 4, endStrawberrySpriteLoopYb
		li $t5, 0
		strawberrySpriteLoopXb:
			beq $t5, 4, endStrawberrySpriteLoopXb
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t7
			
			
			
			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			la $t3, strawberrySprite

			move $t2, $t4
			li $s0, 4
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
			
			#Earase or Draw?
			beq $t8, $zero, eatTheStrawberry
			j doPixelToggleStrawberry
			
			eatTheStrawberry:
			move $a0, $t1
			
			
			doPixelToggleStrawberry:
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j strawberrySpriteLoopXb
			
		endStrawberrySpriteLoopXb:
			addi $t4, $t4, 1
			j strawberrySpriteLoopYb
		
	endStrawberrySpriteLoopYb:    		
    		jr $ra

#Toggle Purple Crystal Visuals: position, mode
togglePurpleCrystal:
	#Get position
	lw $t7, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get mode
	lw $t8, ($sp)
    	addi $sp, $sp, 4

	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
	
	sw $t7, purpleCrystalPos
	
	purpCrystalSpriteLoopYb:
		beq $t4, 3, endPurpCrystalSpriteLoopYb
		li $t5, 0
		PurpCrystalSpriteLoopXb:
			beq $t5, 3, endPurpCrystalSpriteLoopXb
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t7
			
			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			la $t3, purpleCrystalSprite

			move $t2, $t4
			li $s0, 3
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
			
			#Earase or Draw?
			beq $t8, $zero, eatTheAssPurp
			j doPixelTogglePurp
			
			eatTheAssPurp:move $a0, $t1
			
			
			doPixelTogglePurp:
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j PurpCrystalSpriteLoopXb
			
		endPurpCrystalSpriteLoopXb:
			addi $t4, $t4, 1
			j purpCrystalSpriteLoopYb
		
	endPurpCrystalSpriteLoopYb:    		
    		jr $ra	
    		
#Toggle Purple Platform: position, width, height, mode
togglePurplePlatform:
	#Get position
	lw $t7, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get Width
	lw $t8, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get height
	lw $t9, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get mode
	lw $t6, ($sp)
    	addi $sp, $sp, 4
    	    	    	
    	#Update purple plats array
    	beq $t6, $zero, continueToDrawingPurpleThanosAsshole
    	lw $t5, purplePlatsNum
    	la $t4, purplePlatsArray
    	sll $t3, $t5, 4
    	add $t4, $t4, $t3
    	
    	sw $t7, ($t4)
    	addi $t4, $t4, 4
    	sw $t8, ($t4)
    	addi $t4, $t4, 4
    	sw $t9, ($t4)
    	
    	addi $t5, $t5, 1
    	sw $t5, purplePlatsNum
    	
    	continueToDrawingPurpleThanosAsshole:
    	#Draw loop
    	li $t4, 0 #Track our Y 
	li $t5, 0 #Track our X 
	
	pplatformLoopY:
		beq $t4, $t9, endpPlatformLoopY
		li $t5, 0
		pplatformLoopX:
			beq $t5, $t8, endpPlatformLoopX
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t7
			
			#Update Level Array
			la $t2, level
			sll $s0, $t3, 2
			add $t2, $t2, $s0
			
			move $s0, $t6
			sw $s0, ($t2)	

			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			li $a0, 0xaa5ec3
			bne $t6, $zero, putMyBallsIntoAJuicer
			li $a0, BACKGROUND_COLOR
						
			putMyBallsIntoAJuicer:
			addi $sp, $sp, -4
    			sw $t7, ($sp)
			
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j pplatformLoopX
			
		endpPlatformLoopX:
			addi $t4, $t4, 1
			j pplatformLoopY
		
	endpPlatformLoopY:    		
    		jr $ra	
    		
    		
#Make Flag
makeFlag:
	#Get position
	lw $t7, ($sp)
    	addi $sp, $sp, 4
    	
    	blt $t7, $zero, endFlagLoopY
    
	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
	
	sw $t7, flagPos
	
	flagLoopY:
		beq $t4, 5, endFlagLoopY
		li $t5, 0
		flagLoopX:
			beq $t5, 4, endFlagLoopX
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t7
			
			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			la $t3, flagSprite

			move $t2, $t4
			li $s0, 4
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
	
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j flagLoopX
			
		endFlagLoopX:
			addi $t4, $t4, 1
			j flagLoopY
		
	endFlagLoopY:    		
    		jr $ra	
    		
#Reset Current State
resetState:
	li $s7, 0
	li $s6, 0
	li $s5, 0
	li $s4, 0

	sw $zero, flagPos
	sw $zero, numSpikes
	sw $zero, numCrystals
	sw $zero, purplePlatsNum
	li $t2, -1
	sw $t2, strawberryPos

	sw $zero, hasStrawberry
	li $t2, 1
	sw $t2, canDash
	
	li $t2, 0
	li $t3, 4096	

	resetLoop:
		beq $t2, $t3, finishedReset
		
		move $a0, $t1
		move $a1, $t2
		la $a3, drawPixel
		jalr $a2, $a3
		
		#Update Level Array
		la $t4, level
		sll $t5, $t2, 2
		add $t4, $t4, $t5
		sw $zero, ($t4)	
		
		addi $t2, $t2, 1
		
		j resetLoop
	finishedReset:
	
	li $t2, 0
	lw $t3, numCrystals
	clearCyristalsLoop:
		bgt $t2, $t3, finishedCrystalClear
		la $t4, crystalArray
		sw $zero, ($t4)
		
		addi $t4, $t4, 4
		sw $zero, ($t4)
		
		addi $t4, $t4, 4
		sw $zero, ($t4)
		
		addi $t4, $t4, 4
		sw $zero, ($t4)
		
		addi $t2, $t2, 1
		
		j clearCyristalsLoop
		
	finishedCrystalClear:
		sw $zero, numCrystals
		

	
		
	addi $sp, $sp, -4
    	sw $ra, ($sp)
		
	jal loadState
		
	lw $ra, ($sp)
	addi $sp, $sp, 4
		
	jr $ra
	
		
#load State
loadState:
	lw $t9, gameState
	
	li $t2, 0
	beq $t9, $t2, startMenu
	li $t2, 1
	beq $t9, $t2, setUpLevel1
	li $t2, 2
	beq $t9, $t2, setUpLevel2
	li $t2, 3
	beq $t9, $t2, setUpLevel3
	
	li $t2, 100
	beq $t9, $t2, endState
	
	startMenu:
		addi $sp, $sp, -4
    		sw $ra, ($sp)
		
		jal makeStartScreen
		
		lw $ra, ($sp)
		addi $sp, $sp, 4
		
		jr $ra
	
	setUpLevel1:
		addi $sp, $sp, -4
    		sw $ra, ($sp)
		
		jal level1
		
		lw $ra, ($sp)
		addi $sp, $sp, 4
		
		jr $ra
		
	setUpLevel2:
		addi $sp, $sp, -4
    		sw $ra, ($sp)
		
		jal level2
		
		lw $ra, ($sp)
		addi $sp, $sp, 4
		
		jr $ra
		
	setUpLevel3:
		addi $sp, $sp, -4
    		sw $ra, ($sp)
		
		jal level3
		
		lw $ra, ($sp)
		addi $sp, $sp, 4
		
		jr $ra
    	
    	
    	endState:
    		addi $sp, $sp, -4
    		sw $ra, ($sp)
		
		jal makeEndScreen
		
		lw $ra, ($sp)
		addi $sp, $sp, 4
		
		jr $ra
    		
		

#Draw Pixel given color in $a0, position in $a1, and return register in a2
drawPixel: 

	li $t0, BASE_ADDRESS
	li $t7, 4
	mult $t7, $a1
	mflo $t7
	add $t0, $t0, $t7
	
	sw $a0, 0($t0)
	
	
	skipDraw: jr $a2
	
#--------------------------------------------------------------------------------------------------------
#LEVELS
#Start Screen
makeStartScreen:

	li $t9, 1
	sw $t9, nextState

	li $t9, 4098
	sw $t9, playerPos
	
	#Draw Ready Banner
	li $t9, 1041
	drawReady:
	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
		
	readyLoopY:
		beq $t4, 9, endreadyLoopY
		li $t5, 0
		readyLoopX:
			beq $t5, 31, endReadyLoopX
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t9
			
			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			la $t3, ready

			move $t2, $t4
			li $s0, 31
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
	
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j readyLoopX
			
		endReadyLoopX:
			addi $t4, $t4, 1
			j readyLoopY
		
	endreadyLoopY:
	
	#Draw start Banner
	li $t9, 2634
	drawstart:
	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
		
	startLoopY:
		beq $t4, 6, endstartLoopY
		li $t5, 0
		startLoopX:
			beq $t5, 19, endstartLoopX
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t9
			
			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			la $t3, start

			move $t2, $t4
			li $s0, 19
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
	
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j startLoopX
			
		endstartLoopX:
			addi $t4, $t4, 1
			j startLoopY
		
	endstartLoopY:
	
	#Draw Exit Banner
	li $t9, 2731
	drawexit:
	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
		
	exitLoopY:
		beq $t4, 5, endexitLoopY
		li $t5, 0
		exitLoopX:
			beq $t5, 13, endexitLoopX
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t9
			
			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			la $t3, exit

			move $t2, $t4
			li $s0, 13
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
	
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j exitLoopX
			
		endexitLoopX:
			addi $t4, $t4, 1
			j exitLoopY
		
	endexitLoopY:
	
	jr $ra
	

#finishScreen
makeEndScreen:
	li $t9, 4032
	sw $t9, playerPos

	li $t9, 913
	drawEndScreen:
	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
		
	endScreenLoopY:
		beq $t4, 12, endEndScreenLoopY
		li $t5, 0
		endScreenLoopX:
			beq $t5, 31, endEndScreenLoopX
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t9
			
			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			la $t3, youWin

			move $t2, $t4
			li $s0, 31
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
	
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j endScreenLoopX
			
		endEndScreenLoopX:
			addi $t4, $t4, 1
			j endScreenLoopY
		
	endEndScreenLoopY:
	
	#Draw Berry
	li $t9, 2393
	drawBerryX:
	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
		
	BerryXLoopY:
		beq $t4, 5, endBerryXLoopY
		li $t5, 0
		BerryXLoopX:
			beq $t5, 10, endBerryXLoopX
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t9
			
			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			la $t3, BerryX

			move $t2, $t4
			li $s0, 10
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
	
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j BerryXLoopX
			
		endBerryXLoopX:
			addi $t4, $t4, 1
			j BerryXLoopY
		
	endBerryXLoopY:
	
	li $t9, 2405
	
	la $t8, zero
	
	lw $t7, strawberryCount
	
	li $t5, 0
	beq $t7, $t5, zeroBitches	
	li $t5, 1
	beq $t7, $t5, oneBitches
	li $t5, 2
	beq $t7, $t5, twoBitches	
	li $t5, 3
	beq $t7, $t5, threeBitches	
	li $t5, 4
	beq $t7, $t5, threeBitches
	
	zeroBitches:
		la $t8, zero
		j drawNumber
	oneBitches:
		la $t8, one
		j drawNumber
	twoBitches:
		la $t8, two
		j drawNumber
	threeBitches:
		la $t8, three
		j drawNumber
	fourBitches:
		la $t8, four
		j drawNumber
	
	drawNumber:
	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
		
	numberLoopY:
		beq $t4, 5, endNumberLoopY
		li $t5, 0
		numberLoopX:
			beq $t5, 3, endNumberLoopX
			
			#Calculate postion offset of pixel
			move $t3, $t4
			sll $t3, $t3, 6
			add $t3, $t3, $t5
			add $t3, $t3, $t9
			
			#Set a1 to screen position
			move $a1, $t3
			
			#Get color of sprite 
			move $t3, $t8

			move $t2, $t4
			li $s0, 3
			mult $t2, $s0
			mflo $t2
			add $t2, $t2, $t5
			sll $t2, $t2, 2
			add $t3, $t3, $t2
			lw  $a0, ($t3)
			
			addi $sp, $sp, -4
    			sw $t7, ($sp)
	
			#send pixel off for drawing
			la $a3, drawPixel
			jalr $a2, $a3
			
			lw $t7, ($sp)
    			addi $sp, $sp, 4
			
			addi $t5, $t5, 1
			j numberLoopX
			
		endNumberLoopX:
			addi $t4, $t4, 1
			j numberLoopY
		
	endNumberLoopY:    		
	
	jr $ra

#Demo Level Setup
level100:
	
	#Store return address in stack
	addi $sp, $sp, -4
    	sw $ra, ($sp)
    	
    	#Flag
    	li $t2, 3712
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2
    	sw $t2, nextState
    	
    	jal makeFlag

	#Set Up Platforms
	li $t2, 0xdff0000
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3552
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 30
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 4
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Platform 2
    	li $t2, 0xd7bb1eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3078
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 10
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 16
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
	
	#Platform 3
    	li $t2, 0xd7bb1eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2970
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 10
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform

    	#crystal
    	li $t2, 40
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 40
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeCrystal
    	
    	#Reset player stats
    	li $t2, 1000
    	sw $t2, playerPos
    	
    	li $t2, 1
    	sw $t2, playerVelY
    	sw $zero, playerVelX
    	
    	#Spike
    	li $t2, 2118
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeSpikes
    	
    	#Strawberry
    	li $t2, 1
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2150
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal toggleStrawberry
    	
    	#purple crystal
    	li $t2, 1
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2650
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal togglePurpleCrystal
    	
    	#purple platform
    	li $t2, 1
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 10
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 5
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2938
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal togglePurplePlatform
    	
    	#Get return address from stack
    	lw $ra, ($sp)
    	addi $sp, $sp, 4
    	jr $ra
    	
#Level Setup
level1:
	
	#Store return address in stack
	addi $sp, $sp, -4
    	sw $ra, ($sp)
    	
    	#Reset player stats
    	li $t2, 3075
    	sw $t2, playerPos
    	
    	li $t2, 1
    	sw $t2, playerVelY
    	sw $zero, playerVelX
    	
    	#Spike
    	li $t2, 3904
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 16
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeSpikes
    	
    	#Flag
    	li $t2, 3386
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3
    	sw $t2, nextState
    	
    	jal makeFlag

	#Set Up Platforms
	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3584
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	#width
    	li $t2, 10
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	#height
    	li $t2, 8
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Platform 2
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3700
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 12
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 7
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#crystal
    	li $t2, 45
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 20
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeCrystal  	
    	
    	#crystal
    	li $t2, 48
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 33
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeCrystal
    	
    	#crystal
    	li $t2, 52
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 45
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeCrystal
    	
    	#Get return address from stack
    	lw $ra, ($sp)
    	addi $sp, $sp, 4
    	jr $ra
    	
level2:
	
	#Store return address in stack
	addi $sp, $sp, -4
    	sw $ra, ($sp)
    	
    	#Reset player stats
    	li $t2, 2882
    	sw $t2, playerPos
    	
    	li $t2, 1
    	sw $t2, playerVelY
    	sw $zero, playerVelX
    	
    	#Flag
    	li $t2, 1069
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 100
    	sw $t2, nextState
    	
    	jal makeFlag
    	
    	#Spike
    	li $t2, 3918
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeSpikes
    	
    	#Spike
    	li $t2, 2200
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2 	
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeSpikes
    	
    	#Spike
    	li $t2, 3936
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 6 	
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeSpikes
	
	#Platform 1
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3200
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 14
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 14
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Platform 2
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2636
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 7
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Platform 3
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2392
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 8
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 27
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Platform 4
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3638
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 10
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 8
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Platform 5
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 1450
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 9
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 15
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Platform 6
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3003
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 5
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Platform 7
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2355
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 6
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Platform 8
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 1980
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 4
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Platform 9
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 1523
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 4
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#crystal
    	li $t2, 37
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 34
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeCrystal
    	
    	#Strawberry
    	li $t2, 1
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3324
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal toggleStrawberry
    	
    	#purple crystal
    	li $t2, 1
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3370
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal togglePurpleCrystal
    	
    	#purple platform
    	li $t2, 1
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 11
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2937
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal togglePurplePlatform
    	
    	#Get return address from stack
    	lw $ra, ($sp)
    	addi $sp, $sp, 4
    	jr $ra
    	
level3:
	
	#Store return address in stack
	addi $sp, $sp, -4
    	sw $ra, ($sp)
    	
    	#Reset player stats
    	li $t2, 3203
    	sw $t2, playerPos
    	
    	li $t2, 1
    	sw $t2, playerVelY
    	sw $zero, playerVelX
    	
    	#Flag
    	li $t2, 3640
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2
    	sw $t2, nextState
    	
    	jal makeFlag
    	
    	#Spike
    	li $t2, 3914
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 10
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeSpikes
    	
	
	#Platform 1
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3520
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 10
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 9
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Platform 2
    	li $t2, 0x7bc5eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3890
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 14
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 4
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
    	
    	#Strawberry
    	li $t2, 1
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3687
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal toggleStrawberry
    	
    	#purple crystal
    	li $t2, 1
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2716
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal togglePurpleCrystal
    	
    	#purple platform
    	li $t2, 1
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 13
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3358
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal togglePurplePlatform
    	
    	#Get return address from stack
    	lw $ra, ($sp)
    	addi $sp, $sp, 4
    	jr $ra
	
