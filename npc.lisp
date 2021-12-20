(in-package :thirdperson-controller)

(defclass npc (entity) ())

(defmethod initialize ((obj npc))
  (call-next-method))