# Bitmap display starter code
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 512
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
.eqv BASE_ADDRESS 0x10008000

.data
	#Game Setup
	frameDelay: .word 1
	
	#Player Data
	playerPos: .word 95
	playerPrevPos: .word 0 #Used for temp variable storage
	
	playerSpeedX: .word 17 # How many frames per update
	playerSpeedY: .word 10 # How many frames per update
		
	playerVelX: .word 1
	playerVelY: .word 0
	gravity: .word 1
	
	isGrounded: .word 0
	jumping: .word 0
	
	#Player Sprite
	sprite: .word 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000,
	spriteSizeX: .word 4
	spriteSizeY: .word 7
	
	#Random Crap
	newline: .asciiz "\n"
	
.globl main
.text
main: 
	li $t0, BASE_ADDRESS # possition of our painting brush
	li $t1, 0x000000 #stores the color black (for clearing pixels)
	
	#Load in frame buffer values
	li $s7, 0
	li $s6, 0
	
	#Jump Frame AC
	li $s5, 0
	
update: 
	
	
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
	
	
	j update
	
	aPress: 
		li $t5, -1
		sw $t5, playerVelX
		j update
	wPress: 
		#Can't jump if not grounded
		lw $t9, isGrounded
		beq $t9, $zero, update
		
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
		li $t5, 1
		sw $t5, playerVelX
		j update
		
	sPress: 
		li $t5, 0
		sw $t5, playerVelX
		j update


#Update both player position and sprite position on screen
updatePlayer:	

	#Update Player State
	lw $t9, jumping
	lw $t8, isGrounded
	
	#Check if jump is true
	beq $t9, $zero, checkGrounded

	#Jumping Logic
	#--------------------------------------------------------------
	#jumping is true	
	addi $s5, $s5, 1
	li $t7, 15
	bgt $s5, $t7, decreaseYSpeed
	j continueToPosUpdate
	
	decreaseYSpeed:
	#decrease speed as player jumps (to mimik gravity)
	li $s5, 0
	lw $t7, playerSpeedY
	addi $t7, $t7, 3
	sw $t7, playerSpeedY
	li $t6, 50
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
	li $t7, 10
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
		j normalXUpdate
		
		playerWallHit:
			lw $t4, playerVelX
			sub $t4, $zero, $t4
			add $t9, $t9, $t4
			sw $t4, playerVelX
		
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
		beq $t8, $zero, skipYUpdate
		li $s7, 0 # Reset counter
		
		#Ground Collision Check
		move $t6, $t8
		sll $t6, $t6, 6
		
		add $t5, $t6, $t9
		li $t6, 4096
		addi $t4, $t5, 448
		bgt $t4, $t6, grounded
		j notGrounded
		
		#Set player to gounded state
		grounded:
		li $t6, 1
		sw $t6, isGrounded
		
		li $s5, 0
		
		li $v0 1
		li $a0, 1
		syscall
		
		sw $zero, playerVelY
		#Set position to the ground
		li $t6, 64
		div $t9, $t6
		mfhi $t4 #current x
		li $t5, 4096
		subi $t5, $t5, 448
		add $t5, $t5, $t4
		move $t9, $t5
	
		j checkDraw	
		
		#Update player position y	
		notGrounded:		
		move $t9, $t5
		
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
		beq $t4, 7, endOfplayerSpriteLoopY
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
			
			#Get color of sprite 
			la $t3, sprite
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
			addi $t3, $t7, 8
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


#Draw Pixel given color in $a0, position in $a1, and return register in a2
drawPixel: 

	li $t0, BASE_ADDRESS
	li $t7, 4
	mult $t7, $a1
	mflo $t7
	add $t0, $t0, $t7
	
	sw $a0, 0($t0)
	
	
	skipDraw: jr $a2
	
