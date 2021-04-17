# animated_explode_button

An exploding animation with physics based particles to spice up those boring button clicks

![Button animation](assets/button.gif?raw=true "Title")

#Usage 
```Dart

AnimatedExplodeButton(
  onTap: (){
    setState((){
      added = !added
      })
      }   ,
  color: added ? Colors.indigo : Colors.pink,
  child: added
    ? Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration:
                BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(20),
                  ),
        child: Text(
                'Added',
                style: TextStyle(color: Colors.white),
                ),
        )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            decoration:
              BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(20),
              ),
            child: Text(
                      'Add Friend',
                      style: TextStyle(color: Colors.white),
                      ),
        ),
    )

```
