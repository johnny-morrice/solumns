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

// Perform the elimination step
// Update the second array
// with a 1 in each cell that was deleted, a 0 otherwise.
void
elimination_step(short width, short height, char ** grid, char ** record)
{
}
