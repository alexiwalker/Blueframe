class example {
    a:number;
    constructor(a:number){
        this.a = a;
    }
    speak(){
        console.log(this.a)
    }

    changeVar(a:number){
        this.a = a;
        console.log('changed');
    }

    decr(){
        this.a--;
        console.log('decr');
    }
}