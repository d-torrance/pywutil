import unittest
from wutil import WMArray

class WMArrayTest(unittest.TestCase):
    def test_empty_array(self):
        A = WMArray()
        self.assertTrue(isinstance(A, WMArray))
        self.assertEqual(len(A), 0)

    def test_array_copy(self):
        A = WMArray()
        for i in range(3):
            A.append(i)
        B = A.copy()
        C = WMArray(A)
        for i in range(3):
            self.assertEqual(A[i], B[i])
            self.assertEqual(A[i], C[i])

    def test_array_from_list(self):
        L = [1, 2, 3]
        A = WMArray(L)
        for i in range(3):
            self.assertEqual(A[i], L[i])

    def test_array_slicing(self):
        A = WMArray()
        for i in range(10):
            A.append(i)
        B = A[:5]
        self.assertEqual(len(B), 5)
        for i in range(5):
            self.assertEqual(B[i], i)
        C = A[::-1]
        self.assertEqual(len(C), 10)
        for i in range(10):
            self.assertEqual(C[i], 9 - i)

    def test_array_clear(self):
        A = WMArray()
        for i in range(10):
            A.append(i)
        A.clear()
        self.assertEqual(len(A), 0)

    def test__array_extend(self):
        A = WMArray()
        B = WMArray()
        for i in range(5):
            A.append(i)
        for i in range(5, 10):
            B.append(i)
        A.extend(B)
        self.assertEqual(len(A), 10)
        for i in range(10):
            self.assertEqual(A[i], i)

    def test_array_insert(self):
        A = WMArray()
        i = 0
        while i < 10:
            if i != 5:
                A.append(i)
            i += 1
        A.insert(5, 5)
        self.assertEqual(len(A), 10)
        for i in range(10):
            self.assertEqual(A[i], i)

    def test_array_setitem(self):
        A = WMArray()
        for i in range(10):
            A.append(i)
        for i in range(10):
            A[i] += 1
        for i in range(10):
            self.assertEqual(A[i], i + 1)

    def test_array_delitem(self):
        A = WMArray()
        for i in range(10):
            A.append(i)
        for i in range(9, 0, -2):
            del A[i]
        self.assertEqual(len(A), 5)
        for i in range(5):
            self.assertEqual(A[i], 2 * i)

    def test_array_pop(self):
        A = WMArray()
        for i in range(10):
            A.append(i)
        self.assertEqual(A.pop(), 9)
        self.assertEqual(len(A), 9)

    def test_array_count(self):
        A = WMArray()
        for i in range(10):
            j = 0
            while i > j**2:
                j += 1
            A.append(j)
        self.assertEqual(A.count(0), 1)
        self.assertEqual(A.count(1), 1)
        self.assertEqual(A.count(2), 3)
        self.assertEqual(A.count(3), 5)

    def test_array_iter(self):
        A = WMArray()
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

