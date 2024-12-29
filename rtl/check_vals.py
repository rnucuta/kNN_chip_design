import argparse
import os
from pprint import pprint

"""
It is useful to know the max values for the l1, l2, and summed distance for all
the test cases to determine the number of bits needed to represent the distances.
It is also useful for debugging specific test cases to print the 
expected intermediate values for l1, l2 and summed distance to verify your test
bench values. This script gives you both of these functionalities, and is not 
only useful for verifying your test bench values for the distance portion, but 
also verifying your logic in the sorted portion of the design. Review the
arg parser at the bottom of the file to see the different options.

Expected useage:
python3 check_vals.py --get_test_case_stats --inputs_file <path_to_inputs_file>
python3 check_vals.py --test_case <test_case_number> --inputs_file <path_to_inputs_file>

Inputs file should be the inputs.txt file provided for the test bench.
"""

def arr_to_bin_str(arr):
	bin_arr = []
	for num in arr:
		if isinstance(num, tuple):
			pass
			bin_arr.append(arr_to_bin_str(num))
		else:
			bin_arr.append(bin(num))
	return "[" + ", ".join(bin_arr) + "]"

def read_h(h, print_flag = False, bin_mode = 0):
	h = h.split()

	res = []
	diff_all = []
	squared_diff_all = []

	for i in range(1, 9):
		hex1 = h[0]
		if len(hex1) < 16:
			hex1 = "0" * (16-len(hex1)) + hex1
		hex2 = h[i]
		if len(hex2) < 16:
			hex2 = "0" * (16-len(hex2)) + hex2

		vec1 = [int(hex1[j], 16) for j in range(16)]
		vec2 = [int(hex2[j], 16) for j in range(16)]

		diffs = [v1 - v2 for v1, v2 in zip(vec1, vec2)]

		if print_flag:
			if bin_mode == 1:
				pprint("S_{} elementwise l1 dists: {}".format(i-1, arr_to_bin_str(diffs)))
			else:
				print("S_{} elementwise l1 dists: {}".format(i-1, diffs))
		diff_all.extend(diffs)

		squared_diffs = [diff ** 2 for diff in diffs]
		if print_flag:
			if bin_mode == 1:
				pprint("S_{} elementwise l2 dists: {}".format(i-1, arr_to_bin_str(squared_diffs)))
			else:
				print("S_{} elementwise l2 dists: {}".format(i-1, squared_diffs))
			print()
		squared_diff_all.extend(squared_diffs)

		squared_differences_sum = sum(squared_diffs)

		#print(squared_differences_sum)
		#print(bin(squared_differences_sum))
		res.append((squared_differences_sum, i-1))

	if print_flag:
		if bin_mode == 1:
			pprint("Euclidian dists: {}".format(arr_to_bin_str(res)))
			pprint("Sorted distance: {}".format(arr_to_bin_str(sorted(res))))
		else:
			print("Euclidian dists: {}".format(res))
			print("Sorted distance: {}".format(sorted(res)))

	# return max(len(bin(d[0])[2:]) for d in res)
	# return max(res, key = lambda x : x[0])[0]
	return max(diff_all), max(squared_diff_all), max(d[0] for d in res)
	
if __name__=="__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--test_case", type=int, default=0, help="Which test case to print intermediate values for (0-indexed)")
	parser.add_argument("--get_test_case_stats", action="store_true", help="Get max min test case sizes for dist")
	parser.add_argument("--inputs_file", type=str, default="/home/rn347/asap7_rundir/finalproj/temp/inputs.txt", help="inputs.txt file path")
	parser.add_argument("--bit_mode", type=int, default=0, help="0 = decimal, 1 = binary")
	args = parser.parse_args()

	assert os.path.exists(args.inputs_file), "Inputs file path {} does not exist...".format(args.inputs_file)

	with open(args.inputs_file, "r") as f:
		# if get_max_min_stats flag is true, get stats for all test cases
		if args.get_test_case_stats:
			print("Gathering test case stats")
			max_l1_dist = float('-inf')
			max_l2_dist = float('-inf')
			max_summed_dist = float('-inf')

			for h in f:
				tmp_l1, tmp_l2, tmp_sum = read_h(h)
				max_l1_dist = max(max_l1_dist, tmp_l1)
				max_l2_dist = max(max_l2_dist, tmp_l2)
				max_summed_dist = max(max_summed_dist, tmp_sum)
			
			
			print("Max l1: {} ({} bits)".format(max_l1_dist, len(bin(max_l1_dist)[2:])))
			print("Max l2: {} ({} bits)".format(max_l2_dist, len(bin(max_l2_dist)[2:])))
			print("Max d: {} ({} bits)".format(max_summed_dist, len(bin(max_summed_dist)[2:])))

		# or print intermediate results for test case #
		else:
			print("Intermediate values for Test #{}:".format(args.test_case))
			test_case_line = f.readlines()[args.test_case]
			read_h(test_case_line, print_flag = True, bin_mode = args.bit_mode)
