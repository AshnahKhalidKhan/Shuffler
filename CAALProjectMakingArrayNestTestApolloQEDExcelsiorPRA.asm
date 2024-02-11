# Ashnah Khalid Khan	22889
# Syed Danial Haseeb    12429

# Deck Shuffler





.data
    # Line-break
    newLine:    .asciiz     "\n\n"

    # Array containing the four suit symbols
    SUIT:       .byte       'H',    # SUIT[0] = 'H';  // Hearts
                            'D',    # SUIT[1] = 'D';  // Diamonds
                            'C',    # SUIT[2] = 'C';  // Clubs
                            'S'     # SUIT[3] = 'S';  // Spades

    # Representation of a deck of cards in two arrays
    rank:       .space      52      # Array containing the rank
    suit:       .space      52      # Array containing the suit




.text
    li      $t3, -1     # Initialize t3 to -1



    # Loop through all 13 cards, 4 times
    FillRankArray:
        # if (t0 > 3): go to FillSuitArray
        bgt     $t0, 3, FillSuitArray

        # Initialise number-cards counter
        li      $t2, '2'    # t2 = '2'

        AddAce:
            li      $s0, 'A'            # s0 = 'A'
            sb      $s0, rank($t1)      # rank[t1] = s0
            add     $t1, $t1, 1         # t1 += 1


        # Add the number-cards 2 -> 9
        # This loop is possible because the ASCII codes for the
        # characters '2' through '9' are consecutive
        AddNumberCards:
            # if (t2 > '9'): go to AddPictureCards
            bgt     $t2, '9', AddPictureCards
        
            move    $s0, $t2            # s0 = t2
            sb      $s0, rank($t1)      # rank[t0] = s0
            addi    $t1, $t1, 1         # t0 += 1

            addi    $t2, $t2, 1         # t2 += 1
            j       AddNumberCards      # Go back to AddNumberCards
      
      
        # Add the picture-cards T, J, Q, K
        AddPictureCards:
            # Ten
            li      $s0, 'T'            # s0 = 'T'
            sb      $s0, rank($t1)      # rank[t1] = s0
            addi    $t1, $t1, 1         # t1 += 1
            
            # Jack
            li      $s0, 'J'            # s0 = 'J'
            sb      $s0, rank($t1)      # rank[t1] = s0
            addi    $t1, $t1, 1         # t1 += 1
            
            # Queen
            li      $s0, 'Q'            # s0 = 'Q'
            sb      $s0, rank($t1)      # rank[t0] = s0
            addi    $t1, $t1, 1         # t1 += 1
            
            # King
            li      $s0, 'K'            # s0 = 'K'
            sb      $s0, rank($t1)      # rank[t1] = s0
            addi    $t1, $t1, 1         # t0 += 1
            
            # Loop
            addi    $t0, $t0, 1         # t0 += 1
            j       FillRankArray       # Go back to FillRankArray



    FillSuitArray:
        # if (t3 > 3): go to PrintDeck
        bgt     $t3, 3, PrintDeck

        addi    $t3, $t3, 1     # t3 += 1

        li      $t4, 0          # t4 = 0
        j       AddSuits        # Go to AddSuits


        AddSuits:
            # if (t4 > 12): go back to FillSuitArray
            bgt     $t4, 12, FillSuitArray

            lb      $s0, SUIT($t3)      # s0 = SUIT[t3]
            sb      $s0, suit($t5)      # suit[t5] = s0
            add     $t5, $t5, 1         # t5 += 1

            add     $t4, $t4, 1         # t4 += 1
            j       AddSuits            # Go back to AddSuits
    


    PrintDeck:
        # if (t6 > 51): go to PrintNewLine
        bgt     $t6, 51, PrintNewLine

        # Print the rank
        lb      $t1, rank($t6)      # t1 = rank[t6]
        move    $a0, $t1            # a0 = t1
        li      $v0, 11             # Print 
        syscall                     # Systen call
        
        # Print the suit
        lb      $t1, suit($t6)      # t1 = suit[t6]
        move    $a0, $t1            # a0 = t1
        li      $v0, 11             # Print
        syscall                     # System call
    
        # Print a space
        li      $a0, ' '            # a0 = ' '
        li      $v0, 11             # Print
        syscall                     # System call
        
        # Loop
        addi    $t6, $t6, 1         # t6 += 1
        j       PrintDeck



    PrintNewLine:
        la      $a0, newLine        # a0 = newLine
        li      $v0, 4              # Print
        syscall                     # System call

        j       ResetRegisters      # Go to ResetRegisters



    ResetRegisters:
        li      $t0, 0      # t0 = 0
        li      $t2, 0      # t2 = 0
        li      $t3, 0      # t3 = 0
        li      $t6, 0      # t6 = 0

        j       Shuffle     # Go to Shuffle
      


    Shuffle:
        # if (t0 > 51): go to PrintShuffledDeck
        bgt     $t0, 51, PrintShuffledDeck

        # Generate random number between 0 and 51
        li      $a1, 52             # a1 = 52
        li      $v0, 42             # Random number generator
        syscall                     # a0 = rand()

        # Swap the ranks
        lb      $t2, rank($a0)      # t2 = rank[a0]
        lb      $t3, rank($t0)      # t3 = rank[t0]
        sb      $t2, rank($t0)      # rank[t0] = t2   
        sb      $t3, rank($a0)      # rank[a0] = t3

        # Swap the suits
        lb      $t2, suit($a0)      # t2 = suit[a0]
        lb      $t3, suit($t0)      # t3 = suit[t0]
        sb      $t2, suit($t0)      # suit[t0] = t2
        sb      $t3, suit($a0)      # suit[a0] = t3

        # Loop
        addi    $t0, $t0, 1         # t0 += 1
        j       Shuffle             # Go back to Shuffle



    PrintShuffledDeck:
        # if (t6 > 51): go to Halt
        bgt     $t6, 51, Halt

        # Print the rank
        lb      $t1, rank($t6)      # t1 = rank[t6]
        move    $a0, $t1            # a0 = t1
        li      $v0, 11             # Print
        syscall                     # Systen call

        # Print the suit
        lb      $t1, suit($t6)      # t1 = suit[t6]
        move    $a0, $t1            # a0 = t1
        li      $v0, 11             # Print
        syscall                     # System call

        # Print a space
        li      $a0, ' '            # a0 = ' '
        li      $v0, 11             # Print
        syscall                     # System call

        # Loop
        addi    $t6, $t6, 1         # t6 += 1
        j       PrintShuffledDeck   # Go back to PrintShuffledDeck



    Halt:
        li      $v0, 10             # Halt  
        syscall                     # System call
