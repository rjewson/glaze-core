package glaze.signals;

/**
 * Provides a fast signal for use where one parameter is dispatched with the signal.
 */
class Signal1<T1> extends SignalBase<T1->Void> {

    public function dispatch(object1:T1) {
        startDispatch();
        var node = head;
        while (node != null)
        {
            node.listener(object1);
            if (node.once)
                remove(node.listener);
            node = node.next;
        }
        endDispatch();
    }

}
