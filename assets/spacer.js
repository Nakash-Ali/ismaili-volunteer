function spacer(arr, factor, count) {
	if (count === 0) {
		return arr
	}
	const prev_delta = arr[0] - arr[1]
	const next_val = Math.round(100 * (prev_delta * factor + arr[0])) / 100
	// const next_val = Math.round(arr[0] * factor, 2)
	arr.unshift(next_val)
	return spacer(arr, factor, count - 1)
}

console.log(spacer([2, 1], 1.25, 6))
