# Bitmap display starter code
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 512
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#Final Screen pixel is at offset: 16380 = 512 * 32 - 4
.eqv BASE_ADDRESS 0x10008000

.data
	#Game Setup
	frameDelay: .word 1
	
	#Player Data
	#128 units per row
	playerPos: .word 0
	playerPrevPos: .word 0 #Used for temp variable storage (cuz i ran out of registers)
	
	playerSpeed: .word 15 # How many frames per update
	playerUpdateCounter: .word 0
	
	playerVelX: .word 1
	playerVelY: .word 1
	gravity: .word 0
	
	#Player Sprite
	sprite: .word 0xff0000, 28
	spriteSizeX: .word 4
	spriteSizeY: .word 7
	
	#Random Crap
	newline: .asciiz "\n"
	
.globl main
.text
main: 
	li $t0, BASE_ADDRESS # possition of our painting brush
	li $t1, 0x000000 #stores the color black (for clearing pixels)
	
update: 
	
	jal updatePlayer
	

	#sleep command
	la $v0, 32
	lw $a0, frameDelay
	syscall
		 
	
	j update

#closing the game
end:

#Update both player position and sprite position on screen
updatePlayer:	
	#Get velocity
	lw $t7, playerVelX
	lw $t8, playerVelY
	
	#Check if player is moving
	bne $t7, $zero, doPlayerUpdate
	bne $t8, $zero, doPlayerUpdate
	#if player isn't moving, then don't update
	j finishedPlayerUpdate
	
	doPlayerUpdate:
	#-------------------------------------------------------------
	#update playerUpdateCounter and see if we can update the player
	lw $t9, playerUpdateCounter
	addi $t9, $t9,  1
	lw $t6, playerSpeed
	sw $t9, playerUpdateCounter
	blt $t9, $t6, finishedPlayerUpdate
	
	#Reset the update counter once we update the player
	li $t9, 0
	sw $t9, playerUpdateCounter
	#-------------------------------------------------------------
	
	#Get Current Position
	lw $t9, playerPos
	sw $t9, playerPrevPos

	#Update player position x
	add $t9, $t9, $t7
	
	#Update player position y	
	move $t6, $t8
	sll $t6, $t6, 6
	add $t9, $t9, $t6
	
	#Store new position
	sw $t9, playerPos
	
	#Draw new frame
#	li $a0, 0xff0000
#	move $a1, $t9	
#	la $t6, drawPixel
#	jalr $a2, $t6

	li $t4, 0 #Track our Y offset
	li $t5, 0 #Track our X offset
	
	playerSpriteLoopY:
		beq $t4, 7, endOfplayerSpriteLoopY
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
			move $a0, $t4
			sll $a0, $a0, 2
			add $a0, $a0, 4
			
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
			
			#Check if x cord is within the new sprite position 
			addi $t3, $t7, 4
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
			
			#Check if y cord is within the new sprite position 
			addi $t3, $t7, 7
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
		
	
	#Clear previous frame
#	move $a0, $t1
#	move $a1, $t5
#	la $t6, drawPixel
#	jalr $a2, $t6
	
	
	finishedPlayerUpdate: jr $ra


#Draw Pixel given color in $a0, position in $a1, and return register in a2
drawPixel: 
	li $t0, BASE_ADDRESS
	li $t7, 4
	mult $t7, $a1
	mflo $t7
	add $t0, $t0, $t7
	
	#If its already the correct color, then skip
	beq $a0, $t0, skipDraw 
	sw $a0, 0($t0)
	
	skipDraw: jr $a2
	
