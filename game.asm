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
	
	level: .word 0:4096
	
	#Crystal Data
	crystalSprite: .word 0x000000, 0xd4f9bc, 0x000000, 0xd4f9bc, 0xa6e61d, 0xd4f9bc, 0x000000, 0xd4f9bc, 0x000000
	
	#Player Data
	#-------------------------------------------------------------------------------------
	#Player Data
	playerPos: .word 1000
	playerPrevPos: .word 0 #Used for temp variable storage
	
	playerSpeedX: .word 17 # How many frames per update
	playerSpeedY: .word 10 # How many frames per update
		
	playerVelX: .word 1
	playerVelY: .word 0
	gravity: .word 1
	
	isGrounded: .word 0
	jumping: .word 0
	
	dashing: .word 0
	canDash: .word 0
	dashCooldown: .word 0
	
	facingLeft: .word 0
	
	#Player Sprite
	sprite: .word 0x000000, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd7bb1eb, 0xd7bb1eb, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0x000000, 0xd95959, 0x000000, 0xd95959
	leftSprite: .word 0xd95959, 0xd95959, 0xd95959, 0x000000, 0xd7bb1eb, 0xd7bb1eb, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd95959, 0xd000000 0xd95959, 0xd000000
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
	li $t1, 0x000000 #stores the color black (for clearing pixels)
	
	#Load in frame buffer values
	li $s7, 0
	li $s6, 0
	
	#Jump Frame AC
	li $s5, 0
	
	#--------------------------------------------------------------------------
	#Set Up Platforms
	li $t2, 0xdff0000
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 3488
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 30
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 5
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
    	
    	li $t2, 2
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform
	
	#Platform 3
    	li $t2, 0xd7bb1eb
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2842
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 10
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 2
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makePlatform

    	#Platform 3
    	li $t2, 64
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	li $t2, 64
	addi $sp, $sp, -4
    	sw $t2, ($sp)
    	
    	jal makeCrystal
    	
	
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
	beq $t2, 0x6A, jPress  
	beq $t2, 0x6B, kPress    
	
	
	j update
	
	aPress: 
		li $t5, -1
		sw $t5, playerVelX
		j update
		
	#Jumping buttons
	jPress:
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
	
	#Dash Button	
	kPress:
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
			
			#Get color of sprite 
			la $t3, sprite
			
			lw $s0, facingLeft
			bgt $s0, $zero, amogusLeft
			j susAmogusLeft
			amogusLeft:
			la $t3, leftSprite
			
			susAmogusLeft:
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
    	sll $t8, $t8, 6
    	add $t7, $t7, $t9

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

#Draw Pixel given color in $a0, position in $a1, and return register in a2
drawPixel: 

	li $t0, BASE_ADDRESS
	li $t7, 4
	mult $t7, $a1
	mflo $t7
	add $t0, $t0, $t7
	
	sw $a0, 0($t0)
	
	
	skipDraw: jr $a2
	
