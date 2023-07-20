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
	frameDelay: .word 30
	
	#Player Data
	playerX: .word 0
	playerY: .word 0
	playerSpeed: .word 1
	playerVelX: .word 0
	playerVelY: .word 0
	
.globl main
.text
main: 
	li $t0, BASE_ADDRESS # $t0 stores the base address for display
	li $t1, 0xff0000 # $t1 stores the red colour code
	li $t3, 0x000000
	

update: 
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	sw $t1, 0($t0)

	la $v0, 32
	lw $a0, frameDelay
	syscall
	
	 
	
	j update
	
end:
