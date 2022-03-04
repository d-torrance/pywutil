import collections.abc
import cython
cimport cwutil

cdef class WMRange:
    cdef cwutil.WMRange _c_range

    def __cinit__(self, int position, int count):
        self._c_range.position = position
        self._c_range.count = count

cdef class WMArray:
    """
    Dynamically resized array.  The interface is consistent with Python lists.
    """
    cdef cwutil.WMArray * _c_array

    def __cinit__(self, *args):
        if len(args) == 0:
                self._c_array = cwutil.WMCreateArray(0)
        elif len(args) == 1:
            if isinstance(args[0], WMArray):
                self._c_array = cwutil.WMCreateArrayWithArray(
                    (<WMArray>args[0])._c_array)
            elif isinstance(args[0], collections.abc.Iterable):
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

    def copy(self):
        """
        Returns a copy of the array.
        Wrapper around *WMCreateArrayWithArray*.
        """
        return WMArray(self)

    def clear(self):
        """
        Remove all elements of the array.
        Wrapper around *WMEmptryArray*.
        """
        cwutil.WMEmptyArray(self._c_array)

    def __dealloc__(self):
        cwutil.WMFreeArray(self._c_array)

    def __len__(self):
        return cwutil.WMGetArrayItemCount(self._c_array)

    def extend(self, WMArray other):
        """
        Add all elements of *other* at the end of the array.
        Wrapper around *WMAppendArray*.
        """
        cwutil.WMAppendArray(self._c_array, other._c_array)

    def append(self, item):
        """
        Add *item* to the end of the array.
        Wrapper around *WMAddToArray*.
        """
        cwutil.WMAddToArray(self._c_array, <void *>item)

    def insert(self, int index, item):
        """
        Add *item* to the array at position *index*.
        Wrapper around *WMInsertInArray*.
        """
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
        """
        Remove and return the item at the end of the array.
        Wrapper around *WMPopFromArray*.
        """
        ret = cwutil.WMPopFromArray(self._c_array)
        if ret is cython.NULL:
            raise IndexError("pop from empty array")
        else:
            return <object>ret

    def count(self, item):
        """
        Return the number of instances of *item* in the array.
        Wrapper around *WMCountInArray*.
        """
        return cwutil.WMCountInArray(self._c_array, <void *>item)

    def __iter__(self):
        return WMArrayIterator(self)

    def __repr__(self):
        return f"WMArray({list(self)})"

cdef class WMArrayIterator:
    """
    Iterator for WMArray objects.
    The *next* method is a wrapper around *WMArrayFirst* and *WMArrayNext*.
    """
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

cdef class WMBag:
    cdef cwutil.WMBag *_c_bag

    def __cinit__(self):
        self._c_bag = cwutil.WMCreateTreeBag()
        # getting segfaults if I tree to deal with arguments

    def __len__(self):
        return cwutil.WMGetBagItemCount(self._c_bag)

    def extend(self, WMBag other):
        cwutil.WMAppendBag(self._c_bag, other._c_bag)

    def append(self, item):
        cwutil.WMPutInBag(self._c_bag, <void *>item)

    def insert(self, int index, item):
        cwutil.WMInsertInBag(self._c_bag, index, <void*>item)

    def __delitem__(self, int index):
        ret = cwutil.WMDeleteFromBag(self._c_bag, index)
        if ret == 0:
            raise IndexError("bag index out of range")

    def remove(self, item):
        ret = cwutil.WMRemoveFromBag(self._c_bag, <void *>item)
        if ret == 0:
            raise ValueError("bag.remove(x): x not in bag")

    def __getitem__(self, index):
        if isinstance(index, int):
            ret = cwutil.WMGetFromBag(self._c_bag, <int>index)
            if ret is cython.NULL:
                raise IndexError("bag index out of range")
            else:
                return <object>ret
        elif isinstance(index, slice):
            raise NotImplementedError("bag slicing not implemented")
        else:
            raise TypeError("bag indices must be integers or slices, "
                            f"not {type(index).__name__}")

    def __setitem__(self, int index, item):
        ret = cwutil.WMReplaceInBag(self._c_bag, index, <void*>item)
        if ret is cython.NULL:
            raise IndexError("bag index out of range")

    def clear(self):
        cwutil.WMEmptyBag(self._c_bag)

    def __dealloc__(self):
        cwutil.WMFreeBag(self._c_bag)

    def count(self, item):
        return cwutil.WMCountInBag(self._c_bag, <void *>item)

    def __iter__(self):
        return WMBagIterator(self)

cdef class WMBagIterator:
    cdef void *ptr
    cdef cwutil.WMBag *_c_bag
    cdef bint first

    def __init__(self, WMBag bag):
        self._c_bag = bag._c_bag
        self.first = True

    def __iter__(self):
        return self

    def __next__(self):
        if self.first:
            ret = cwutil.WMBagFirst(self._c_bag, &self.ptr)
            self.first = False
        else:
            ret = cwutil.WMBagNext(self._c_bag, &self.ptr)
        if ret is cython.NULL:
            raise StopIteration
        else:
            return <object>ret
