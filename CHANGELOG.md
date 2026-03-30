# 1.0.1

- **Fix**: `initialValue` was ignored — picker always started at `max / 2` instead of the specified initial value.
- **Fix**: `onChanged` callback and haptic feedback fired on every scroll tick instead of only when the value actually changed.
- **Chore**: Remove unused empty `Text` widget in `RangedRulerPickerItemView`.
- **Chore**: Remove redundant `interval == 0` check (already guarded by assertion).

# 1.0.0

- Initial version.