async function payment(request) {
    return new Promise((resolve, reject) => {
        request = JSON.parse(request)
        var container = document.getElementById('dropin-container');
        if (container != null) {
            container.innerHTML = "";
        }
        braintree.dropin.create(request,
            (errCreate, instance) => {
                console.log("Check1");
                if (errCreate) {
                    console.log("Error", errCreate);
                    return reject(errCreate);
                }
                return resolve(instance)
            }
        );
    });
}

async function requestPaymentMethod(instance) {
    return new Promise((resolve, reject) => {
                        instance.requestPaymentMethod((errRequest, payload) => {
                            if (errRequest) {
                                console.log("Error", errRequest);
                                return reject(errRequest);
                            }
                            return resolve(JSON.stringify(payload));
                        });
    });
}