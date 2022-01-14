(in-package :thirdperson-controller)

(defclass npc (entity) ())

(defmethod initialize-instance :after ((instance npc) &rest initargs &key &allow-other-keys))
