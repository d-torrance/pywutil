cdef extern from "WINGs/WUtil.h":
    ctypedef struct WMArray:
        pass

    ctypedef struct WMRange:
        int position
        int count

    WMArray* WMCreateArray(int initialSize)
    # WMArray* WMCreateArrayWithDestructor(int initialSize,
    #                                      WMFreeDataProc *destructor)
    WMArray* WMCreateArrayWithArray(WMArray *array)
    void WMEmptyArray(WMArray *array)
    void WMFreeArray(WMArray *array)
    int WMGetArrayItemCount(WMArray *array)
    void WMAppendArray(WMArray *array, WMArray *other)
    void WMAddToArray(WMArray *array, void *item)
    void WMInsertInArray(WMArray *array, int index, void *item)
    void* WMReplaceInArray(WMArray *array, int index, void *item)
    int WMDeleteFromArray(WMArray *array, int index)
    # int WMRemoveFromArrayMatching(WMArray *array, WMMatchDataProc *match,
    #                              void *cdata)
    void* WMGetFromArray(WMArray *array, int index)
    void* WMPopFromArray(WMArray *array)
    # int WMFindInArray(WMArray *array, WMMatchDataProc *match, void *cdata)
    int WMCountInArray(WMArray *array, void *item)
    # void WMSortArray(WMArray *array, WMCompareDataProc *comparer)
    # void WMMapArray(WMArray *array, void (*function)(void*, void*),
    #                 void *data)
    WMArray* WMGetSubarrayWithRange(WMArray* array, WMRange aRange)
    void* WMArrayFirst(WMArray *array, int *iter)
    void* WMArrayNext(WMArray *array, int *iter)
    # void* WMArrayPrevious(WMArray *array, WMArrayIterator *iter)

    ctypedef struct WMBag:
        pass

    WMBag* WMCreateTreeBag()
    # WMBag* WMCreateTreeBagWithDestructor(WMFreeDataProc *destructor)
    int WMGetBagItemCount(WMBag *bag)
    void WMAppendBag(WMBag *bag, WMBag *other)
    void WMPutInBag(WMBag *bag, void *item)
    void WMInsertInBag(WMBag *bag, int index, void *item)
    # int WMEraseFromBag(WMBag *bag, int index)
    int WMDeleteFromBag(WMBag *bag, int index)
    int WMRemoveFromBag(WMBag *bag, void *item)
    void* WMGetFromBag(WMBag *bag, int index)
    void* WMReplaceInBag(WMBag *bag, int index, void *item)
    # void WMSortBag(WMBag *bag, WMCompareDataProc *comparer)
    void WMEmptyBag(WMBag *bag)
    void WMFreeBag(WMBag *bag)
    # void WMMapBag(WMBag *bag, void (*function)(void*, void*), void *data)
    int WMGetFirstInBag(WMBag *bag, void *item)
    int WMCountInBag(WMBag *bag, void *item)
    # int WMFindInBag(WMBag *bag, WMMatchDataProc *match, void *cdata)
    void* WMBagFirst(WMBag *bag, void **ptr);
    # void* WMBagLast(WMBag *bag, WMBagIterator *ptr);
    void* WMBagNext(WMBag *bag, void **ptr)
    # void* WMBagPrevious(WMBag *bag, WMBagIterator *ptr)
    # void* WMBagIteratorAtIndex(WMBag *bag, int index, WMBagIterator *ptr)
    # int WMBagIndexForIterator(WMBag *bag, WMBagIterator ptr)
