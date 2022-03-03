import collections.abc
import cython
from cpython.ref cimport PyObject
cimport cwutil

cdef class WMRange:
    cdef cwutil.WMRange _c_range

    def __cinit__(self, int position, int count):
        self._c_range.position = position
        self._c_range.count = count

cdef class WMArray:
    cdef cwutil.WMArray * _c_array

    def __cinit__(self, *args):
        if len(args) == 0:
                self._c_array = cwutil.WMCreateArray(0)
        elif len(args) == 1:
            if isinstance(args[0], collections.abc.Iterable):
                self._c_array = cwutil.WMCreateArray(0)
                for x in args[0]:
                    self.append(x)
            else:
                raise TypeError(f"'{type(args[0]).__name__}' not iterable")
        elif len(args) == 2 and isinstance(args[0], WMArray) and \
             isinstance(args[1], slice):
            (start, stop, stride) = args[1].indices(len(args[0]))
            if stride == 1:
                self._c_array = cwutil.WMGetSubarrayWithRange(
                    (<WMArray>args[0])._c_array,
                    WMRange(start, stop - start)._c_range)
            else:
                self._c_array = cwutil.WMCreateArray(0)
                for i in range(start, stop, stride):
                    self.append(args[0][i])
        else:
            raise TypeError("expected an iterable or WMArray")

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
            return WMArray(self, index)
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
