/* 
 * Copyright 2011 John Morrice
 *
 * This file is part of Solumns. 
 *
 * Solumns is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Foobar is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY * without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Solumns.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

// This file provides functions used by solumns/grid.rkt.
// Specifically, it provides fast elimation of squares with 3 neighbours of same colour.

// In Racket, #f is handled speedily.  In C, we don't have anything like it.
// Therefore, before passing any colours to this file, they should be incremented by 1,
// and #f should be converted to 0.  This file will return or write colours back in that same format.

#include <stdlib.h>
#include <stdio.h>

// Find minimum, given a scalar element of grid position
unsigned char minimum(unsigned char n)
{
	if (n == 0)
	{
		return 0;
	}
	else
	{
		return n - 1;
	}
}

// Find maximum, given a scalar element of grid position and a boundry such that bound > n
unsigned char maximum(unsigned char n, unsigned char bound)
{
	if (n == bound - 1)
	{
		return n;
	}
	else
	{
		return n + 1;
	}
}

// Take a cell location, the grid, the tags and the record
// If a cell, or any of its neighbours has more than 2 neighbours (a tag >= 3)
// Mark it as deleted in the record
void
mark_delete(const unsigned char colour,
		const unsigned char x,
		const unsigned char y,
		const unsigned char width,
		const unsigned char height,
		unsigned char ** const grid,
		unsigned char ** const tag,
		unsigned char ** const record)
{
	// Iterative variables for exploring nearby cells
	unsigned char i, j;
	// Min and max in x direction
	const unsigned char min_i = minimum(x);
	const unsigned char max_i = maximum(x, width);
	// Min and max in y direction
	const unsigned char min_j = minimum(y);
	const unsigned char max_j = maximum(y, height);

	// Iterate through nearby cells
	for (i = min_i; i <= max_i; i++)
	{
		for (j = min_j; j <= max_j; j++)
		{
			if (grid[i][j] == colour && tag[i][j] >= 3)
			{
				record[x][y] = grid[x][y];
				return;
			}
		}
	}
}
		

// Take the colour at the current cell,
// the location of the current cell.
// update the record if the cell has two or more neighbours of its colour
void
tag_cell(const unsigned char colour,
		const unsigned char x,
		const unsigned char y,
		const unsigned char width,
		const unsigned char height,
		unsigned char ** const grid,
		unsigned char ** const tag)
{
	// Iterative variables for exploring nearby cells
	unsigned char i, j;
	// Min and max in x direction
	const unsigned char min_i = minimum(x);
	const unsigned char max_i = maximum(x, width);
	// Min and max in y direction
	const unsigned char min_j = minimum(y);
	const unsigned char max_j = maximum(y, height);

	// The number of nearby cells of the same colour
	unsigned char nearby = 0;

	// Iterate through nearby cells
	for (i = min_i; i <= max_i; i++)
	{
		for (j = min_j; j <= max_j; j++)
		{
			// If the colour at this square is the same as our colour, note it
			if (colour == grid[i][j])
			{
				nearby++;
			}
		}
	}

	// Update the tagging matrix
	tag[x][y] = nearby;

}

// Free a matrix
#if defined (__WINDOWS__)
__declspec(dllexport)
#endif
void
free_matrix(unsigned char width, unsigned char ** matrix)
{
	// Iterative variable
	unsigned char i;

	// Free the matrix 
	for (i = 0; i < width; i++)
	{
		free(matrix[i]);
	}

	free(matrix);
}

// DIE DIE DIE
void
fatal_out_of_memory()
{
	fprintf(stderr, "elimination_step: could not assign memory for tag row\n");
	exit(EXIT_FAILURE);
}

// Create a new matrix
#if defined (__WINDOWS__)
__declspec(dllexport)
#endif
unsigned char **
new_matrix(const unsigned char width,
		const unsigned char height)
{

	// Iterative variable
	unsigned char i;

	// The new matrix
	unsigned char ** const matrix = malloc(sizeof(char *) * width);
	if (!matrix)
	{
		fatal_out_of_memory();

	}
	for (i = 0; i < width; i ++)
	{
		matrix[i] = malloc(sizeof(char) * height);
		if (!matrix[i])
		{
			fatal_out_of_memory();
		}
	}

	return matrix;
}



// Perform the elimination step
// Update the second array
// with a the colour of each cell that was deleted.
#if defined (__WINDOWS__)
__declspec(dllexport)
#endif
unsigned char **
elimination_step(const unsigned char width,
		const unsigned char height,
		unsigned char ** const grid)
{
	// Iterative variables for traversing the grid
	unsigned char i, j;
	// The colour of the current cell
	unsigned char cell;
	// Tagging matrix
	unsigned char ** const tag = new_matrix(width, height);
	// Record
	unsigned char ** const record = new_matrix(width, height);

	// All zeros in the record
	for (i = 0; i < width; i++)
	{
		for (j = 0; j < height; j++)
		{
			record[i][j] = 0;
		}
	}
       

	// Iterate over the whole grid, rows first
	for (i = 0; i < width; i++)
	{
		// Then iterate over columns
		for (j = 0; j < height; j ++)
		{
			// Set the current cell
			cell = grid[i][j];

			// If the cell is coloured, we're interested
			if (cell)
			{
				tag_cell(cell, i, j, width, height, grid, tag); 
			}
			// Otherwise we've reached the top of the pile, and are not interested.
			else
			{
				break;
			}


		}

	}

	// Work out which cells can be deleted
	for (i = 0; i < width; i++)
	{
		for (j = 0; j < height; j++)
		{
			cell = grid[i][j];
			if (cell)
			{
				// Perhaps the cell can be deleted, if so mark it
				mark_delete(cell, i, j, width, height, grid, tag, record);
			}
			else
			{
				break;
			}
		}
	}

	// Delete the marked cells
	for (i = 0; i < width; i++)
	{
		for (j = 0; j < height; j++)
		{
			if (record[i][j])
			{
				grid[i][j] = 0;
			}
		}
	}

	free_matrix(width, tag);
	
	return record;
}
