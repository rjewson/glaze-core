package glaze.signals;

/**
 * Provides a fast signal for use where no parameters are dispatched with the signal.
 */
class Signal0 extends SignalBase<Void->Void> {

    public function dispatch() {
        startDispatch();
        var node = head;
        while (node != null)
        {
            node.listener();
            if (node.once)
                remove(node.listener);
            node = node.next;
        }
        endDispatch();
    }

}
