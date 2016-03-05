# Resetting a go live date

Bring up the pod in the console and set `go_live_date` to nil.

    p = Pod.where(id: 41)[0]
    p.go_live_date = nil
    p.save
