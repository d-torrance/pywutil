import collections.abc
import cython
from cpython.ref cimport PyObject
cimport cwutil

cdef class WMArray:
    cdef cwutil.WMArray * _c_array

    def __init__(self, iterable=None):
        if iterable is None:
            self._c_array = cwutil.WMCreateArray(0)
        elif isinstance(iterable, collections.abc.Iterable):
            self._c_array = cwutil.WMCreateArray(0)
            for x in iterable:
                self.append(x)
        else:
            raise TypeError(f"'{type(iterable).__name__}' not iterable")

    def clear(self):
        cwutil.WMEmptyArray(self._c_array)

    def __dealloc__(self):
        cwutil.WMFreeArray(self._c_array)

    def __len__(self):
        return cwutil.WMGetArrayItemCount(self._c_array)

    def extend(self, WMArray other):
        cwutil.WMAppendArray(self._c_array, other._c_array)

    def append(self, item):
        cwutil.WMAddToArray(self._c_array, <void *>item)

    def insert(self, int index, item):
        cwutil.WMInsertInArray(self._c_array, index, <void*>item)

    def __setitem__(self, int index, item):
        ret = cwutil.WMReplaceInArray(self._c_array, index, <void*>item)
        if ret is cython.NULL:
            raise IndexError("array index out of range")

    def __delitem__(self, int index):
        ret = cwutil.WMDeleteFromArray(self._c_array, index)
        if ret == 0:
            raise IndexError("array index out of range")

    def __getitem__(self, index):
        if isinstance(index, int):
            ret = cwutil.WMGetFromArray(self._c_array, <int>index)
            if ret is cython.NULL:
                raise IndexError("array index out of range")
            else:
                return <object>ret
        elif isinstance(index, slice):
            raise NotImplementedError("slices not implemented yet")
        else:
            raise TypeError("array indices must be integers or slices, "
                            f"not {type(index).__name__}")

    def pop(self):
        ret = cwutil.WMPopFromArray(self._c_array)
        if ret is cython.NULL:
            raise IndexError("pop from empty array")
        else:
            return <object>ret

    def count(self, item):
        return cwutil.WMCountInArray(self._c_array, <void *>item)

    def __iter__(self):
        return WMArrayIterator(self)

    def __repr__(self):
        return f"WMArray({list(self)})"

cdef class WMArrayIterator:
    cdef int index
    cdef cwutil.WMArray *_c_array

    def __init__(self, WMArray array):
        self._c_array = array._c_array
        self.index = -1

    def __iter__(self):
        return self

    def __next__(self):
        if self.index == -1:
            ret = cwutil.WMArrayFirst(self._c_array, &self.index)
        else:
            ret = cwutil.WMArrayNext(self._c_array, &self.index)
        if ret is cython.NULL:
            raise StopIteration
        else:
            return <object>ret
