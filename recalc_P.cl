__kernel void recalc_P( __global const int *mv,
			__global const int *rt,
			__global const int *Uidx,
			__global const float *U,
			__global const float *V,
			__global const int *dims,
			__global int *out)
{

	int gid = get_global_id(0);

	int d = dims[0]; // Number of feature dimensions
	int p = dims[1]; // Number of nyms to choose from
	int m = dims[2]; // Number of movies

	int min_idx = -1;
	float min_sum;

	// // Figure out the first index for the loop.
	// int fromidx;
	// if (gid == 0)
	// 	fromidx = 0;
	// else
	// 	fromidx = Uidx[gid - 1];

	int i, z, k;
	float row_sum, entry;

	for  (i = 0 ; i < p ; i++) // Loop through nyms
	{
		row_sum = 0.0;
		for (z = Uidx[gid]; z < Uidx[gid+1]; z++) // Loop through users' ratings
		{
			entry = rt[z];
			for (k = 0; k < d; k++) // calculating Utilde^T.V for this movie
				entry -= U[k * p + i] * V[k * m + mv[z]]; // mv[z] is current movie id

			row_sum += entry*entry;
		}

		if (i == 0 || row_sum < min_sum)
		{
			min_sum = row_sum;
			min_idx = i;
		}
	}

	out[gid] = min_idx;
	return;
}
