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
.eqv BACKGROUND_COLOR 0x000000

.data

	#Game Setup
	frameDelay: .word 1
	
	level: .word 0:4096
	
	#Spike Data
	spikeSprite: .word BACKGROUND_COLOR, 0xdadada, BACKGROUND_COLOR, BACKGROUND_COLOR, 0xc6c6c6, BACKGROUND_COLOR, 0xb2b2b2, 0xb2b2b2, 0xb2b2b2
	numSpikes: .word 0
	spikeArray: .word 0:40 #position, count
	
	#Crystal Data
	crystalSprite: .word BACKGROUND_COLOR, 0xd4f9bc, BACKGROUND_COLOR, 0xd4f9bc, 0xa6e61d, 0xd4f9bc, BACKGROUND_COLOR, 0xd4f9bc, BACKGROUND_COLOR
	numCrystals: .word 0
	crystalArray: .word 0:16 # position, isActive, coolDown, coolDownTimer
	
	
	
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
	
	#Player Sprite
	sprite: .word BACKGROUND_COLOR, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd7bb1eb, 0xd7bb1eb, 0xd95959, 0xd95959, 0xd95959, 0xd95959, BACKGROUND_COLOR, 0xd95959, BACKGROUND_COLOR, 0xd95959
	leftSprite: .word 0xd95959, 0xd95959, 0xd95959, BACKGROUND_COLOR, 0xd7bb1eb, 0xd7bb1eb, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd000000 0xd95959, 0xd000000
	dashSprite: .word BACKGROUND_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, 0xd7bb1eb, 0xd7bb1eb, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, BACKGROUND_COLOR, DASH_COLOR, BACKGROUND_COLOR, DASH_COLOR
	leftDashSprite: .word DASH_COLOR, DASH_COLOR, DASH_COLOR, BACKGROUND_COLOR, 0xd7bb1eb, 0xd7bb1eb, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, DASH_COLOR, 0xd000000 DASH_COLOR, 0xd000000
	spriteSizeX: .word 4
	spriteSizeY: .word 7
	#-------------------------------------------------------------------------------------
	
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
	
	jal level1	
	
update: 
	jal spikeUpdate
	jal crystalUpdate
	jal updatePlayer
	

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
		#Can't momentum cancel if dashing
		lw $t9, dashing
		bne $t9, $zero, update
	
		li $t5, 1
		sw $t5, playerVelX
		j update
		
	sPress: 
		#Can't momentum cancel if dashing
		lw $t9, dashing
		bne $t9, $zero, update
		
		li $t5, 0
		sw $t5, playerVelX
		j update
		
	pPress: 
		jal resetState
		jal level1
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
		bgt $t2, $t3, endcrystalUpdateLoop
		
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
		beq $t2, $t3, endSpikeUpdateLoop
		
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
			jal level1
			
			lw $ra, ($sp)
    			addi $sp, $sp, 4
    			
    			j noSpikeOverlap    			
    		
	noSpikeOverlap:
		addi $t2,  $t2, 1
		j crystalUpdateLoop
	endSpikeUpdateLoop:
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
	
	#Increment Crystal Count
	lw $t9, numCrystals
	addi $t9, $t9 ,1
	sw $t9, numCrystals

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
    	sw $t7, ($t2)
    	addi $t2, $t2, 4
    	li $t3, 1
    	sw $t3, ($t2)
    	addi $t2, $t2, 4
    	sw $zero, ($t2)
    	addi $t2, $t2, 4
    	sw $zero, ($t2)

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

	lw $t9, numSpikes
	addi $t9, $t9 ,1
	sw $t9, numSpikes

	#Get count
	lw $t8, ($sp)
    	addi $sp, $sp, 4
    	
    	#Get position
	lw $t7, ($sp)
    	addi $sp, $sp, 4
    	
    	la $t2, spikeArray
    	sw $t7, ($t2)
    	addi $t2, $t2, 4
    	sw $t8, ($t2)
    	
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


#Reset Current State
resetState:
	li $s7, 0
	li $s6, 0
	li $s5, 0
	li $s4, 0

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
		beq $t2, $t3, finishedCrystalClear
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
#Level Setup
level1:
	
	#Store return address in stack
	addi $sp, $sp, -4
    	sw $ra, ($sp)

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
    	
    	#Get return address from stack
    	lw $ra, ($sp)
    	addi $sp, $sp, 4
    	jr $ra
	
