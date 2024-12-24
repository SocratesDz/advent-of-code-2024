const std = @import("std");

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("Advent has come\n", .{});
}

test "Compare sorted numbers" {
    const input: []const u8 =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;

    // 1. Extract numbers from input
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();

    var list1 = std.ArrayList(i32).init(allocator);
    var list2 = std.ArrayList(i32).init(allocator);

    var iterator = std.mem.tokenizeAny(u8, input, "\n");
    while (iterator.next()) |line| {
        var split_line_iterator = std.mem.tokenizeScalar(u8, line, ' ');

        if (split_line_iterator.next()) |num1| {
            const integer = try std.fmt.parseInt(i32, num1, 10);
            try list1.append(integer);
        }
        if (split_line_iterator.next()) |num2| {
            const integer = try std.fmt.parseInt(i32, num2, 10);
            try list2.append(integer);
        }
    }

    try std.testing.expect(list1.items.len == 6);
    try std.testing.expect(list2.items.len == 6);

    // 2. Sort the lists
    std.mem.sort(i32, list1.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, list2.items, {}, std.sort.asc(i32));
    // 3. Calculate distance between elements
    var distance_sum: u32 = 0;
    for (list1.items, list2.items) |l1, l2| {
        // 4. Sum the distances
        distance_sum += @abs(l1 - l2);
    }

    try std.testing.expect(distance_sum == 11);
}
