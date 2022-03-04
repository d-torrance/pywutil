import unittest
from wutil import WMBag

class WMBagTest(unittest.TestCase):
    def test_empty_bag(self):
        A = WMBag()
        self.assertTrue(isinstance(A, WMBag))
        self.assertEqual(len(A), 0)

    # def test_bag_copy(self):
    #     A = WMBag()
    #     for i in range(3):
    #         A.append(i)
    #     B = A.copy()
    #     C = WMBag(A)
    #     for i in range(3):
    #         self.assertEqual(A[i], B[i])
    #         self.assertEqual(A[i], C[i])

    # def test_bag_from_list(self):
    #     L = [1, 2, 3]
    #     A = WMBag(L)
    #     for i in range(3):
    #         self.assertEqual(A[i], L[i])

    # def test_bag_slicing(self):
    #     A = WMBag()
    #     for i in range(10):
    #         A.append(i)
    #     B = A[:5]
    #     self.assertEqual(len(B), 5)
    #     for i in range(5):
    #         self.assertEqual(B[i], i)
    #     C = A[::-1]
    #     self.assertEqual(len(C), 10)
    #     for i in range(10):
    #         self.assertEqual(C[i], 9 - i)

    def test_bag_clear(self):
        A = WMBag()
        for i in range(10):
            A.append(i)
        A.clear()
        self.assertEqual(len(A), 0)

    def test_bag_extend(self):
        A = WMBag()
        B = WMBag()
        for i in range(5):
            A.append(i)
        for i in range(5, 10):
            B.append(i)
        A.extend(B)
        self.assertEqual(len(A), 10)
        for i in range(10):
            self.assertEqual(A[i], i)

    def test_bag_insert(self):
        A = WMBag()
        i = 0
        while i < 10:
            if i != 5:
                A.append(i)
            i += 1
        A.insert(5, 5)
        self.assertEqual(len(A), 10)
        for i in range(10):
            self.assertEqual(A[i], i)

    def test_bag_setitem(self):
        A = WMBag()
        for i in range(10):
            A.append(i)
        for i in range(10):
            A[i] += 1
        for i in range(10):
            self.assertEqual(A[i], i + 1)

    def test_bag_delitem(self):
        A = WMBag()
        for i in range(10):
            A.append(i)
        for i in range(9, 0, -2):
            del A[i]
        self.assertEqual(len(A), 5)
        for i in range(5):
            self.assertEqual(A[i], 2 * i)

    # def test_bag_pop(self):
    #     A = WMBag()
    #     for i in range(10):
    #         A.append(i)
    #     self.assertEqual(A.pop(), 9)
    #     self.assertEqual(len(A), 9)

    def test_bag_count(self):
        A = WMBag()
        for i in range(10):
            j = 0
            while i > j**2:
                j += 1
            A.append(j)
        self.assertEqual(A.count(0), 1)
        self.assertEqual(A.count(1), 1)
        self.assertEqual(A.count(2), 3)
        self.assertEqual(A.count(3), 5)

    def test_bag_iter(self):
        A = WMBag()
        for i in range(10):
            A.append(i)
        i = 0
        j = iter(A)
        while True:
            try:
                self.assertEqual(next(j), i)
            except StopIteration:
                break
            i += 1

